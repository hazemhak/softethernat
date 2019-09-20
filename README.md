<p>Softether VPN server installer script version for public use. This should install and configure everything with one command.</p>
<p>From there you can change the server admin password and add/remove users from the Softether Server Manager GUI as desired.</p>
<p>As the root user run the below command via ssh.</p>
<p><br />Softether VPN server installed as service with custom systemd script<br />Dnsmasq DHCP server. This improves the performance of softether vpn vs the built in &ldquo;securenat DHCP server&rdquo;.</p>
<p><br />Custom Iptables script to automate any rules and port forwarding</p>
<p>Adblocking built in via hosts file thanks to Nomadturk</p>
<p>Logless VPN mod. With my custom script, even the stuff Softether doesn&rsquo;t natively support disabling is prevented and purged.</p>
<p>See here for the details.</p>
<p>wget https://raw.githubusercontent.com/hazemhak/softethernat/master/softether-vpnserver-install.sh; chmod a+x softether-vpnserver-install.sh &amp;&amp; bash softether-vpnserver-install.sh;</p>
<p>&nbsp;</p>
<p>To enable, start,and check status of the systemd Softether vpn service.</p>
<p>systemctl start vpnserver<br />systemctl stop vpnserver<br />systemctl restart vpnserver<br />systemctl status vpnserver</p>
<p>To enable, start,and check status of the systemd Dnsmasq DHCP service. This is autostarted by vpnserver service but if needed the below are the commands to manage it.</p>
<p>systemctl start dnsmasq<br />systemctl stop dnsmasq<br />systemctl restart dnsmasq<br />systemctl status dnsmasq</p>
<p>Default vpn user is 'test' with password 'softethervpn'</p>
<p>Default Server administrator password is 'softethervpn'</p>
<p>To manage the server via Windows Server GUI grab the Server Manager client from <a href="https://github.com/SoftEtherVPN/SoftEtherVPN_Stable/releases/download/v4.29-9680-rtm/softether-vpnserver_vpnbridge-v4.29-9680-rtm-2019.02.28-windows-x86_x64-intel.exe">https://github.com/SoftEtherVPN/SoftEtherVPN_Stable/releases/download/v4.29-9680-rtm/softether-vpnserver_vpnbridge-v4.29-9680-rtm-2019.02.28-windows-x86_x64-intel.exe</a></p>
<p><br /><br />To connect to the VPN grab and install the softether vpn client from:</p>
<p>http://www.softether-download.com/en.aspx?product=softether</p>
<p>Complete<br />root@softethertest:/root#<br />After installed.<br />Default user &ldquo;test&rdquo;<br />Default pass &ldquo;softethervpn&rdquo; for user and Server Administrator.</p>
<p>The iptables should look like the below:</p>
<p>root@softethertest:/root# iptables --list</p>
<p>It also installs 2 cronjobs to automatically purge logs and update adblocking hosts file.</p>
<p>root@softethertest:/root# crontab -l</p>
<p>If you do not have a VPS we sell amazing KVM Proxmox based VPS&rsquo;s with IPv4/IPv6 and there perfect for hosting your own VPN.</p>
<p><br />If your looking for a quality logless VPN provider and don't want to worry about installing or managing a VPS head on over to our VPN page and get signed up and let us handle the heavy lifting. <br />Special thanks and shout out to the below blog posts authors. This script is a mashup of all the best things I found from all these posts. I used their posts for inspiration. I tweaked this to be the best combination of them all and valid for use today and in an installer script with my own personal touches to make it easy enough and fast for anyone to install and secure their online communications.</p>
<p>https://az.cokh.net/softether-vpn-server-on-a-nat-server/<br />http://blog.lincoln.hk/blog/2013/03/19/softether-on-vps/</p>
