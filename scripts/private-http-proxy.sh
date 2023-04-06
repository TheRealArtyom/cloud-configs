#!/bin/sh

apt update && apt dist-upgrade -y
apt install squid apache2-utils

mkdir /root/.ssh
echo ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC64hlbFGDRAFm4fbVnNNhNBuev7LMZNrfUe7xkzUvcXgkuJVqSDI86D7rEHtIvriKPi4qB6wzOAKyw4RDPOplRgIXxE461FBFjteh2AxLUiHS8JnbTe/ojctD4pPr1nTH8R4j/foQcy7pb0yA4Lay4bKSiEadp8eczB7STnZh+r5h5pwppRM5HUkxuT+Ur5+bp54Ffe80AazcO+fA3B5+WO9v6eEMIT8jI3hZhdrfrQ6aZUF7B2aIq8HbXm/cHoXjce4+99ggmnYoyb/lmREAV6McbqANHtdvHGGMvtPg1EjQGNa5sRc2BbE2eDIj3wS/uz+vOKXPtk8zOx4/LKbF1 Artjom Ott > /root/.ssh/authorized_keys
systemctl restart ssh

htpasswd -b -c /etc/squid/passwords artyom sunrise
systemctl start squid
systemctl enable squid
sed -i '1403i\auth_param basic program /usr/lib/squid3/basic_ncsa_auth /etc/squid/passwords' /etc/squid/squid.conf
sed -i '1404i\auth_param basic realm proxy' /etc/squid/squid.conf
sed -i '1405i\acl authenticated proxy_auth REQUIRED' /etc/squid/squid.conf
sed -i '1406i\http_access allow authenticated' /etc/squid/squid.conf
systemctl restart squid
reboot now
