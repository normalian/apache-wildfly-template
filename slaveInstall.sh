#!/bin/bash

MY_IP=`ifconfig eth0 | grep inet[^6] | sed 's/.*inet[^6][^0-9]*\([0-9.]*\)[^0-9]*.*/\1/'`
MASTERIP=$1
ADMIN_PASSWORD=$2
PASSWORD_HASH=`echo $ADMIN_PASSWORD | openssl enc -e -base64`

# JDK Install
yum install -y java-1.8.0-openjdk

# setup wildfly modules
wget http://download.jboss.org/wildfly/10.0.0.Final/wildfly-10.0.0.Final.zip
unzip -q wildfly-10.0.0.Final.zip
mv wildfly-10.0.0.Final/ /opt/
ln -s /opt/wildfly-10.0.0.Final /opt/wildfly
cp /opt/wildfly/docs/contrib/scripts/init.d/wildfly.conf /etc/default/
cp /opt/wildfly/docs/contrib/scripts/init.d/wildfly-init-redhat.sh /etc/init.d/wildfly
mkdir -p /var/log/wildfly

# setting for user running wildfly
adduser wildfly
chown -R wildfly:wildfly /opt/wildfly/
chown -R wildfly:wildfly /opt/wildfly-10.0.0.Final/
chown -R wildfly:wildfly /var/log/wildfly/

# wildfly config setting for slave
sed -i 's/# JBOSS_HOME=/JBOSS_HOME=/g' /etc/default/wildfly.conf
sed -i 's/# JBOSS_USER=/JBOSS_USER=/g' /etc/default/wildfly.conf
sed -i 's/# JBOSS_MODE=standalone/JBOSS_MODE=domain/g' /etc/default/wildfly.conf
sed -i 's/# JBOSS_DOMAIN_CONFIG=domain.xml/JBOSS_DOMAIN_CONFIG=domain.xml/g' /etc/default/wildfly.conf
sed -i 's/# JBOSS_HOST_CONFIG=host-master.xml/JBOSS_HOST_CONFIG=host-slave.xml/g' /etc/default/wildfly.conf

# wildfly setup for domain mode
sed -i "s/jboss.bind.address.management:127.0.0.1/jboss.bind.address.management:$MY_IP/g" /opt/wildfly/domain/configuration/host-slave.xml
sed -i "s/jboss.bind.address:127.0.0.1/jboss.bind.address:$MY_IP/g" /opt/wildfly/domain/configuration/host-slave.xml
sed -i "s/\${jboss.domain.master.address\}/$MASTERIP/g" /opt/wildfly/domain/configuration/host-slave.xml
sed -i "s/\(^.*secret value=\"\)\([^\"]*\)\(\".*\)$/\1$PASSWORD_HASH\3/g" /opt/wildfly/domain/configuration/host-slave.xml
sed -i "s/remote security-realm=\"ManagementRealm\"/remote security-realm=\"ManagementRealm\" username=\"admin\"/g" /opt/wildfly/domain/configuration/host-slave.xml 

# running wildfly as a service 
chkconfig --add wildfly
chkconfig wildfly on
service wildfly start

echo "end setup wildfly slave script" >> /root/message.txt