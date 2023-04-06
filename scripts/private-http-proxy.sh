#!/bin/sh

apt update && apt dist-upgrade -y
apt install -y squid apache2-utils

htpasswd -b -c /etc/squid/passwords artyom sunrise
systemctl start squid
systemctl enable squid

sed -i '1403i\auth_param basic program /usr/lib/squid3/basic_ncsa_auth /etc/squid/passwords' /etc/squid/squid.conf
sed -i '1404i\auth_param basic realm proxy' /etc/squid/squid.conf
sed -i '1405i\acl authenticated proxy_auth REQUIRED' /etc/squid/squid.conf
sed -i '1406i\http_access allow authenticated' /etc/squid/squid.conf

sed -i "1399i\acl proxy0 myip $1" /etc/squid/squid.conf
sed -i "1400i\tcp_outgoing_address $1 proxy0" /etc/squid/squid.conf

systemctl restart squid

wget https://raw.githubusercontent.com/TheRealArtyom/cloud-configs/main/scripts/add-ip.sh

echo "rebooting..."
reboot now
