#!/bin/sh

apt update && apt dist-upgrade -y
apt install squid apache2-utils

htpasswd -b -c /etc/squid/passwords artyom sunrise
systemctl start squid
systemctl enable squid
sed -i '1403i\auth_param basic program /usr/lib/squid3/basic_ncsa_auth /etc/squid/passwords' /etc/squid/squid.conf
sed -i '1404i\auth_param basic realm proxy' /etc/squid/squid.conf
sed -i '1405i\acl authenticated proxy_auth REQUIRED' /etc/squid/squid.conf
sed -i '1406i\http_access allow authenticated' /etc/squid/squid.conf
systemctl restart squid
reboot now
