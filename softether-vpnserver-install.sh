#!/bin/bash
#SoftEther VPN Server install for Ubuntu/Debian.
# Copyleft (C) 2019 WhatTheServer - All Rights Reserved
# Permission to copy and modify is granted under the CopyLeft license

#Update the OS if not already done.
apt-get -y update && apt-get -y upgrade

#Install essentials
apt-get -y install build-essential libssl-dev g++ openssl libpthread-stubs0-dev gcc-multilib dnsmasq

#Backup dnsmasq conf
mv /etc/dnsmasq.conf /etc/dnsmasq.conf-bak

#disable UFW firewall
ufw disable

#Stop UFW
service ufw stop

#Flush Iptables
iptables -F && iptables -X

#Grab latest Softether link for Linux x64 from here: http://www.softether-download.com/en.aspx?product=softether

#Use wget to copy it directly onto the server.
wget https://github.com/SoftEtherVPN/SoftEtherVPN_Stable/releases/download/v4.29-9680-rtm/softether-vpnserver-v4.29-9680-rtm-2019.02.28-linux-x64-64bit.tar.gz

#Extract it. Enter directory and run make and agree to all license agreements:
tar xvf softether-vpnserver-*.tar.gz
cd vpnserver
printf '1\n1\n1\n' | make

#Move up and then copy Softether libs to /usr/local
cd ..
mv vpnserver /usr/local
cd /usr/local/vpnserver/
chmod 600 *
chmod 700 vpncmd
chmod 700 vpnserver

#grab Softether vpn server.config template
wget -O /usr/local/vpnserver/vpn_server.config https://raw.githubusercontent.com/hazemhak/softethernat/master/vpn_server.config

#Create systemd init file for Softether VPN service
wget -O /lib/systemd/system/vpnserver.service https://raw.githubusercontent.com/hazemhak/softethernat/master/vpnserver.service
#Grab DNSMasq conf
wget -O /etc/dnsmasq.conf https://raw.githubusercontent.com/hazemhak/softethernat/master/dnsmasq.conf
wget -O /etc/logrotate.d/dnsmasq https://raw.githubusercontent.com/hazemhak/softethernat/master/dnsmasq

shopt -s extglob; NET_INTERFACE=$(ip link | awk -F: '$0 !~ "lo|vir|wl|tap_soft|^[^0-9]"{print $2;getline}'); NET_INTERFACE="${NET_INTERFACE##*( )}"; sed -i s/ens3/"$NET_INTERFACE"/g /etc/dnsmasq.conf; shopt -u extglob;

#ad blocking hosts
wget -O /root/updateHosts.sh https://raw.githubusercontent.com/nomadturk/vpn-adblock/master/updateHosts.sh; chmod a+x /root/updateHosts.sh && bash /root/updateHosts.sh;

#Install adblocking cron.
command="/root/updateHosts.sh >/dev/null 2>&1"
job="0 0 * * * $command"
cat <(fgrep -i -v "$command" <(crontab -l)) <(echo "$job") | crontab -

#Grab needed Log purging 
wget -O /root/softetherlogpurge.sh https://raw.githubusercontent.com/hazemhak/softethernat/master/softetherlogpurge.sh; chmod a+x /root/softetherlogpurge.sh;

#Install Log purging.
command2="/root/softetherlogpurge.sh >/dev/null 2>&1"
job2="* * * * * $command2"
cat <(fgrep -i -v "$command2" <(crontab -l)) <(echo "$job2") | crontab -


#Grab ipv4 enabling and execute it
wget -O /root/sysctl-forwarding.sh https://raw.githubusercontent.com/hazemhak/softethernat/master/sysctl-forwarding.sh; chmod a+x /root/sysctl-forwarding.sh && bash /root/sysctl-forwarding.sh;

#Grab base Sofether Iptables rules
wget -O /root/softether-iptables.sh https://raw.githubusercontent.com/hazemhak/softethernat/master/softether-iptables.sh; chmod a+x /root/softether-iptables.sh;
# install monit 
apt-get install monit
systemctl enable monit
systemctl start monit
systemctl status monit
wget -O /etc/monit/monitrc https://raw.githubusercontent.com/hazemhak/softethernat/master/monit/monitrc
wget -O /etc/monit/conf-enabled/openssh-server https://raw.githubusercontent.com/hazemhak/softethernat/master/monit/openssh-server
wget -O /etc/monit/conf-enabled/cron https://raw.githubusercontent.com/hazemhak/softethernat/master/monit/cron
wget -O /etc/monit/conf-enabled/dnsmasq https://raw.githubusercontent.com/hazemhak/softethernat/master/monit/dnsmasq
wget -O /etc/monit/conf-enabled/vpnserver https://raw.githubusercontent.com/hazemhak/softethernat/master/monit/vpnserver
systemctl restart monit

#Make ethers file for dnsmasq to do static assignments based on Mac Addresses
touch /etc/ethers

echo "Configuration files locations"
echo "Dnsmasq /etc/dnsmasq.conf"
echo "Iptables /root/softether-iptables.sh"
echo "SoftEther vpn_server.config /usr/local/vpnserver/vpn_server.config"
echo "Softether systemd service /lib/systemd/system/vpnserver.service"

#To enable, start,and check status of the systemd dnsmasq dhcp service.
systemctl enable vpnserver dnsmasq
systemctl daemon-reload; systemctl stop dnsmasq.service; systemctl start dnsmasq.service; systemctl restart vpnserver;
systemctl status vpnserver dnsmasq


echo "To enable, start,and check status of the systemd Softether vpn service."
echo "systemctl start vpnserver"
echo "systemctl stop vpnserver"
echo "systemctl restart vpnserver"
echo "systemctl status vpnserver"

echo "To enable, start,and check status of the systemd Dnsmasq DHCP service. This is autostarted by vpnserver service but if needed the below are the commands to manage it."
echo "systemctl start dnsmasq"
echo "systemctl stop dnsmasq"
echo "systemctl restart dnsmasq"
echo "systemctl status dnsmasq"

echo "If configuration files for dnsmaq or the softether systemd script the below command will need to be done to reload and startup the services."
echo "systemctl daemon-reload; systemctl stop dnsmasq.service; systemctl start dnsmasq.service; systemctl restart vpnserver;"

echo "Default vpn user is 'test' with password 'softethervpn'"
echo "Default Server administrator password is 'softethervpn'"
echo "To manage the server via Windows Server GUI grab the Server Manager client from https://github.com/SoftEtherVPN/SoftEtherVPN_Stable/releases/download/v4.29-9680-rtm/softether-vpnserver_vpnbridge-v4.29-9680-rtm-2019.02.28-windows-x86_x64-intel.exe"
VPNEXTERNALIP=$(hostname -I | cut -d ' ' -f 1)
echo "Connect to $VPNEXTERNALIP:443"
echo "To connect to the VPN grab and install the softether vpn client from: http://www.softether-download.com/en.aspx?product=softether"
echo "Complete"
