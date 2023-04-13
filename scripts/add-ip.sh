#!/bin/sh

#iface=ens3
#file=/etc/network/interfaces.d/50-cloud-init

sed -i "1399i\acl proxy$1 myip $2" /etc/squid/squid.conf
sed -i "1400i\tcp_outgoing_address $2 proxy$1" /etc/squid/squid.conf

#echo "auto $iface:$1" >> $file
#echo "iface $iface:$1 inet static" >> $file
#echo "    address $2" >> $file
#echo "    netmask 255.255.255.255" >> $file
#echo "" >> $file

systemctl restart networking
systemctl restart squid
