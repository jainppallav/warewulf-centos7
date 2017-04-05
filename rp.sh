#!/bin/bash

echo "Correcting Service link" 
ln -s /usr/lib/systemd/system/mysqld.service /etc/rc.d/init.d/mysqld
ln -s /usr/lib/systemd/system/nfs-server.service nfsd
ln -s /usr/lib/systemd/system/ntpd.service /etc/rc.d/init.d/ntpd

echo "Correcting permission "
chmod +x /etc/rc.d/init.d/nfsd
chmod +x /etc/rc.d/init.d/mysqld
chmod +x /etc/rc.d/init.d/ntpd
echo"Correcting service name"
####NFS#######
sed -i '27s/SERVICE_NAME="nfs"/SERVICE_NAME="nfs-server"/' usr/libexec/warewulf/wwinit/50-nfsd.init
####TFTP######
sed -i '14s/no/yes/' /etc/xinetd.d/tftp
sed -i '34s/^/#/' 50-tftp.init
sed -i '35s/^/#/' 50-tftp.init
sed -i '36s/^/#/' 50-tftp.init
sed -i '36s/xinetd/tftp/' 50-tftp.init
####HTTP######
sed -i  '17i\    \Require all granted' /etc/httpd/conf.d/warewulf-httpd.conf

sed -i  '29i\    \Require all granted' /etc/httpd/conf.d/warewulf-httpd.conf

sed -i '27s/Order allow,deny/#Order allow,deny/' /etc/httpd/conf.d/warewulf-httpd.conf

sed -i '28s/#Allow from all/#Allow from all/' /etc/httpd/conf.d/warewulf-httpd.conf

sed -i '17s/UserDir disabled/#UserDir disabled/' /etc/httpd/conf.d/userdir.conf

sed  '24s/#UserDir public_html/UserDir public_html/' /etc/httpd/conf.d/userdir.conf
####DHCP######
echo "Enter your private network adapter"
read adapt
sed -i '4s/network device/#network device/' /etc/warewulf/provision.conf
sed -i "4i network device = $adapt" /etc/warewulf/provision.conf
