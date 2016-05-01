#!/bin/bash

# yum -y update
yum install -y httpd
# wget -q --wait=5 https://raw.githubusercontent.com/normalian/linux-vm-customscript/master/index.html
# mv -f index.html /var/www/html/
systemctl start httpd

echo "end setup httpd script" >> /root/message.txt

