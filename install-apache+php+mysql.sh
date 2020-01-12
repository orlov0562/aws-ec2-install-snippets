#!/bin/bash

# https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-lamp-amazon-linux-2.html
# https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/install-LAMP.html

SERVER_NAME="Web Server"
MYSQL_ROOT_PASS="mysql"

yum update -y
amazon-linux-extras install -y lamp-mariadb10.2-php7.2 php7.2
yum install -y mc wget curl htop httpd mariadb-server

rm /var/www/html/index.html
echo '<html><body>' > /var/www/html/index.php
echo "<h1>$SERVER_NAME.</h1>" >> /var/www/html/index.php
echo '<hr><h2>$_REQUEST</h2><pre><?php print_r($_REQUEST)?></pre>' >> /var/www/html/index.php
echo '<hr><h2>$_SERVER</h2><pre><?php print_r($_SERVER)?></pre>' >> /var/www/html/index.php
echo '</body></html>' >> /var/www/html/index.php
echo "<?php phpinfo(); ?>" > /var/www/html/phpinfo.php
wget -O /var/www/html/adminer.php https://www.adminer.org/latest.php

usermod -a -G apache ec2-user
chown -R ec2-user:apache /var/www
sudo chmod 2775 /var/www && find /var/www -type d -exec sudo chmod 2775 {} \;
find /var/www -type f -exec sudo chmod 0664 {} \;

systemctl start php-fpm httpd mariadb
systemctl enable php-fpm httpd mariadb

mysql -u root <<-EOF
UPDATE mysql.user SET Password=PASSWORD('$MYSQL_ROOT_PASS') WHERE User='root';
DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1');
DELETE FROM mysql.user WHERE User='';
DELETE FROM mysql.db WHERE Db='test' OR Db='test_%';
FLUSH PRIVILEGES;
EOF
