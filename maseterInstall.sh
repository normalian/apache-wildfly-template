#!/bin/bash

# yum -y update
# yum install -y httpd
# systemctl start httpd
MASTERIP=$1
ADMIN_USERNAME=$2
ADMIN_PASSWORD=$3

# JDK Install
yum install -y java-1.8.0-openjdk

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

# config file setting for slave
sed -i 's/# JBOSS_HOME=/JBOSS_HOME=/g' /etc/default/wildfly.conf
sed -i 's/# JBOSS_USER=/JBOSS_USER=/g' /etc/default/wildfly.conf
sed -i 's/# JBOSS_MODE=standalone/JBOSS_MODE=domain/g' /etc/default/wildfly.conf
sed -i 's/# JBOSS_DOMAIN_CONFIG=domain.xml/JBOSS_DOMAIN_CONFIG=domain.xml/g' /etc/default/wildfly.conf

# add wildfly admin user  
/opt/wildfly/bin/add-user.sh $ADMIN_USERNAME $ADMIN_PASSWORD

# setup for domain
sed -i "s/jboss.bind.address.management:127.0.0.1/jboss.bind.address.management:$MASTERIP/g" /opt/wildfly/domain/configuration/host.xml
sed -i "s/jboss.bind.address:127.0.0.1/jboss.bind.address:$MASTERIP/g" /opt/wildfly/domain/configuration/host.xml

# running wildfly as a service 
chkconfig --add wildfly
chkconfig wildfly on
service wildfly start

echo "end setup wildfly master script" >> /root/message.txt
