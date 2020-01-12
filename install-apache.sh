#!/bin/bash
yum -y update
yum -y install httpd
echo '<html><body><h1>Web Server 1</h1></body></html>' > /var/www/html/index.html;
service httpd start
chkconfig httpd on
