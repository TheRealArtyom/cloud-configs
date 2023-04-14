#!/bin/sh


# add ssh key
#mkdir /root/.ssh
#echo ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC64hlbFGDRAFm4fbVnNNhNBuev7LMZNrfUe7xkzUvcXgkuJVqSDI86D7rEHtIvriKPi4qB6wzOAKyw4RDPOplRgIXxE461FBFjteh2AxLUiHS8JnbTe/ojctD4pPr1nTH8R4j/foQcy7pb0yA4Lay4bKSiEadp8eczB7STnZh+r5h5pwppRM5HUkxuT+Ur5+bp54Ffe80AazcO+fA3B5+WO9v6eEMIT8jI3hZhdrfrQ6aZUF7B2aIq8HbXm/cHoXjce4+99ggmnYoyb/lmREAV6McbqANHtdvHGGMvtPg1EjQGNa5sRc2BbE2eDIj3wS/uz+vOKXPtk8zOx4/LKbF1 Artjom Ott > /root/.ssh/authorized_keys
#systemctl restart ssh


# update the system
apt update && apt dist-upgrade -y
apt install -y squid apache2-utils ufw


# apply firewall
ufw --force enable && ufw allow ssh && ufw allow 3128/tcp


# install node exporter
sh <(curl -s https://raw.githubusercontent.com/TheRealArtyom/cloud-configs/main/scripts/node-exporter.sh)
ufw allow from 94.130.227.146 proto tcp to any port 9100


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
htpasswd -b -c /etc/squid/passwords $1 $2
systemctl start squid
systemctl enable squid


# add proxy authentication
sed -i '1403i\auth_param basic program /usr/lib/squid3/basic_ncsa_auth /etc/squid/passwords' /etc/squid/squid.conf
sed -i '1404i\auth_param basic realm proxy' /etc/squid/squid.conf
sed -i '1405i\acl authenticated proxy_auth REQUIRED' /etc/squid/squid.conf
sed -i '1406i\http_access allow authenticated' /etc/squid/squid.conf


# add default ip
#sed -i "1399i\acl proxy0 myip $1" /etc/squid/squid.conf
#sed -i "1400i\tcp_outgoing_address $1 proxy0" /etc/squid/squid.conf


# restart 
systemctl restart squid


# download our tools
#wget https://raw.githubusercontent.com/TheRealArtyom/cloud-configs/main/scripts/add-ip.sh


echo ""
echo ""
echo ""
echo ""
echo "done. rebooting..."
reboot now
