<a href="https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fnormalian%2Fapache-wildfly-template%2Fmaster%2Fazuredeploy.json" target="_blank">
    <img src="http://azuredeploy.net/deploybutton.png"/>
</a>
<a href="http://armviz.io/#/?load=https%3A%2F%2Fraw.githubusercontent.com%2Fnormalian%2Fapache-wildfly-template%2Fmaster%2Fazuredeploy.json" target="_blank">
    <img src="http://armviz.io/visualizebutton.png"/>
</a>

# Install WildFly cluster with ARM templates
This template deploys a WildFly master node on an CentOS 7.x virtual machines and multiple WildFly slave nodes on other multiple VMs into Microsoft Azure. These templates also provision a storage account, virtual network, availability sets, public IP addresses and network interfaces required by the installation.

You can login the WildFly management portal via http://"your dns name"."your location".cloudapp.azure.com:9990/console after installation completed, and you can find master and slave nodes like below.
![WildFly management portal](https://raw.githubusercontent.com/normalian/apache-wildfly-template/master/img/wildfly_cluster.png "WildFly management portal")

## Reference
- WildFly 9 Cluster Howto https://docs.jboss.org/author/display/WFLY9/WildFly+9+Cluster+Howto

## Known Issues and Limitations

- This template does not currently install Apache.
- This template does not currently setup mod_cluster. mod_cluster-1.3.1.Final, CentOS Linux release 7.2.1511 (Core) and httpd-2.4.6-40.el7.centos.x86_64 don't work.
