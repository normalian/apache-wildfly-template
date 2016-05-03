# Install WildFly cluster on vnet ARM template for Microsoft Azure 
This template deploys a WildFly master node on an CentOS 7.x virtual machines and multiple WildFly slave nodes on other multiple VMs. This template also provisions a storage account, virtual network, availability sets, public IP addresses and network interfaces required by the installation.

You can login the WildFly management portal via http://<your dns name>.<your location>.cloudapp.azure.com:9990/console, and you can find master and slave nodes like below.
[https://raw.githubusercontent.com/normalian/apache-wildfly-template/master/img/wildfly_cluster.png]

## Reference
- WildFly 9 Cluster Howto https://docs.jboss.org/author/display/WFLY9/WildFly+9+Cluster+Howto

## Known Issues and Limitations

- This template does not currently install Apache.
- This template does not currently setup mod_cluster. This version 