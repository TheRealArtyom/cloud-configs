#!/bin/sh

# update the system
apt update && apt dist-upgrade -y
apt install -y squid apache2-utils

# apply custom network config, we don't need ipv6
#echo "auto lo" > /etc/network/interfaces.d/50-cloud-init
#echo "iface lo inet loopback" >> /etc/network/interfaces.d/50-cloud-init
#echo "    dns-nameservers 213.186.33.99" >> /etc/network/interfaces.d/50-cloud-init
#echo "" >> /etc/network/interfaces.d/50-cloud-init
#echo "auto ens3" >> /etc/network/interfaces.d/50-cloud-init
#echo "iface ens3 inet dhcp" >> /etc/network/interfaces.d/50-cloud-init
#echo "    accept_ra 0" >> /etc/network/interfaces.d/50-cloud-init
#echo "    mtu 1500" >> /etc/network/interfaces.d/50-cloud-init
#echo "" >> /etc/network/interfaces.d/50-cloud-init

#systemctl restart networking

# create user
htpasswd -b -c /etc/squid/passwords marius kTH9fZjQAgyDWewVxeyszsUe7UzaeQ85
systemctl start squid
systemctl enable squid

# add authentication
sed -i '1403i\auth_param basic program /usr/lib/squid3/basic_ncsa_auth /etc/squid/passwords' /etc/squid/squid.conf
sed -i '1404i\auth_param basic realm proxy' /etc/squid/squid.conf
sed -i '1405i\acl authenticated proxy_auth REQUIRED' /etc/squid/squid.conf
sed -i '1406i\http_access allow authenticated' /etc/squid/squid.conf

# add default ip
sed -i "1399i\acl proxy0 myip $1" /etc/squid/squid.conf
sed -i "1400i\tcp_outgoing_address $1 proxy0" /etc/squid/squid.conf

# restart 
systemctl restart squid

# download our tools
#wget https://raw.githubusercontent.com/TheRealArtyom/cloud-configs/main/scripts/add-ip.sh

echo "rebooting..."
reboot now
