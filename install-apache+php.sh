#!/bin/bash
amazon-linux-extras install -y lamp-mariadb10.2-php7.2
#rm /var/www/html/index.html
echo '<html><body><h1>Web Server 1. Time: <?=time()?></h1></body></html>' > /var/www/html/index.php;
systemctl start php-fpm httpd
systemctl enable php-fpm httpd
