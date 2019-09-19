Well after of a lot of tinkering was able to get this amazing Softether VPN server installer script version for public use. This should install and configure everything with one command. From there you can change the server admin password and add/remove users from the Softether Server Manager GUI as desired.

As the root user run the below command via ssh.


Softether VPN server installed as service with custom systemd script
Dnsmasq DHCP server. This improves the performance of softether vpn vs the built in “securenat DHCP server”.
Custom Iptables script to automate any rules and port forwarding
Adblocking built in via hosts file thanks to Nomadturk
Logless VPN mod. With my custom script, even the stuff Softether doesn’t natively support disabling is prevented and purged. See here for the details.

wget https://raw.githubusercontent.com/hazemhak/softethernat/master/softether-vpnserver-install.sh; chmod a+x softether-vpnserver-install.sh && bash softether-vpnserver-install.sh;


Once completed it will look something like the below.

To enable, start,and check status of the systemd Softether vpn service.

systemctl start vpnserver
systemctl stop vpnserver
systemctl restart vpnserver
systemctl status vpnserver

To enable, start,and check status of the systemd Dnsmasq DHCP service. This is autostarted by vpnserver service but if needed the below are the commands to manage it.

systemctl start dnsmasq
systemctl stop dnsmasq
systemctl restart dnsmasq
systemctl status dnsmasq
Default vpn user is 'test' with password 'softethervpn'
Default Server administrator password is 'softethervpn'
To manage the server via Windows Server GUI grab the Server Manager client from https://github.com/SoftEtherVPN/SoftEtherVPN_Stable/releases/download/v4.29-9680-rtm/softether-vpnserver_vpnbridge-v4.29-9680-rtm-2019.02.28-windows-x86_x64-intel.exe
Connect to 182.1.50.1:443
To connect to the VPN grab and install the softether vpn client from: http://www.softether-download.com/en.aspx?product=softether
Complete
root@softethertest:/root#
After installed.
Default user “test”
Default pass “softethervpn” for user and Server Administrator.

The iptables should look like the below:

root@softethertest:/root# iptables --list

It also installs 2 cronjobs to automatically purge logs and update adblocking hosts file.

root@softethertest:/root# crontab -l

If you do not have a VPS we sell amazing KVM Proxmox based VPS’s with IPv4/IPv6 and there perfect for hosting your own VPN.


﻿If your looking for a quality logless VPN provider and don't want to worry about installing or managing a VPS head on over to our VPN page and get signed up and let us handle the heavy lifting. 
Special thanks and shout out to the below blog posts authors. This script is a mashup of all the best things I found from all these posts. I used their posts for inspiration. I tweaked this to be the best combination of them all and valid for use today and in an installer script with my own personal touches to make it easy enough and fast for anyone to install and secure their online communications.

https://az.cokh.net/softether-vpn-server-on-a-nat-server/
http://blog.lincoln.hk/blog/2013/03/19/softether-on-vps/
