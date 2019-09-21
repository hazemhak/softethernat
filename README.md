<p style="text-align: center;"><span style="color: #000000;"><span style="color: #993300;"><strong>Softether VPN server installer script</strong> </span></span></p>
<p><span style="color: #000000;">version for public use. This should install and configure everything with one command.</span></p>
<p><span style="color: #000000;">From there you can change the server admin password and add/remove users from the Softether Server Manager GUI as desired.</span></p>
<p>As the root user run the below command via ssh.</p>
<p><br />Softether VPN server installed as service with custom systemd script<br />Dnsmasq DHCP server. This improves the performance of softether vpn vs the built in &ldquo;securenat DHCP server&rdquo;.</p>
<p><br />Custom Iptables script to automate any rules and port forwarding</p>
<p>Adblocking built in via hosts file thanks to Nomadturk</p>
<p>Logless VPN mod. With my custom script, even the stuff Softether doesn&rsquo;t natively support disabling is prevented and purged.</p>
<p>See here for the details.</p>
<p>wget<span style="color: #333399;"> https://raw.githubusercontent.com/hazemhak/softethernat/master/softether-vpnserver-install.sh; </span>chmod<span style="color: #333399;"> a+x </span>softether<span style="color: #333399;">-</span>vpnserver<span style="color: #333399;">-install.sh &amp;&amp; bash </span>softether<span style="color: #333399;">-</span>vpnserver<span style="color: #333399;">-install.sh;</span></p>
<p>To enable, start,and check status of the systemd Softether vpn service.</p>
<p>systemctl<span style="color: #333399;"> start </span>vpnserver<br />systemctl<span style="color: #333399;"> stop </span>vpnserver<br />systemctl<span style="color: #333399;"> restart </span>vpnserver<br />systemctl<span style="color: #333399;"> status </span>vpnserver</p>
<p>To enable, start,and check status of the systemd Dnsmasq DHCP service. This is autostarted by vpnserver service but if needed the below are the commands to manage it.</p>
<p>systemctl<span style="color: #333399;"> start </span>dnsmasq<br />systemctl<span style="color: #333399;"> stop </span>dnsmasq<br />systemctl<span style="color: #333399;"> restart </span>dnsmasq<br />systemctl<span style="color: #333399;"> status </span>dnsmasq</p>
<p>Default vpn user is 'test' with password 'softethervpn'</p>
<p>Default Server administrator password is 'softethervpn'</p>
<p>To manage the server via Windows Server GUI grab the Server Manager client from <a href="https://github.com/SoftEtherVPN/SoftEtherVPN_Stable/releases/download/v4.29-9680-rtm/softether-vpnserver_vpnbridge-v4.29-9680-rtm-2019.02.28-windows-x86_x64-intel.exe">https://github.com/SoftEtherVPN/SoftEtherVPN_Stable/releases/download/v4.29-9680-rtm/softether-vpnserver_vpnbridge-v4.29-9680-rtm-2019.02.28-windows-x86_x64-intel.exe</a></p>
<p><br />Default user &ldquo;test&rdquo;<br />Default pass &ldquo;softethervpn&rdquo; for user and Server Administrator.</p>
<p>The iptables should look like the below:</p>
<p>iptables<span style="color: #333399;"> --list</span></p>
<p>It also installs 2 cronjobs to automatically purge logs and update adblocking hosts file.</p>
<p><span style="color: #333399;">&nbsp;crontab -l</span></p>
<p><strong>and Also install </strong>monit<strong>&nbsp;to monitor the server</strong> and vpnserver&nbsp;,&nbsp;dhcp&nbsp;server ,ssh server ,corn&nbsp;.&nbsp;and you can access it by&nbsp;</p>
<p><a href="http://x.x.y.y:2812">http://x.x.y.y:2812</a></p>
<p>username : admin</p>
<p>password : admin</p>
<p><strong>and also install </strong>webmin<strong>&nbsp;and you can access it by&nbsp;</strong></p>
<p><a href="https://x.x.y.y:10000">https://x.x.y.y:10000</a></p>
<p><br />Special thanks and shout out to the below blog posts authors. This script is a mashup of all the best things I found from all these posts. I used their posts for inspiration. I tweaked this to be the best combination of them all and valid for use today and in an installer script with my own personal touches to make it easy enough and fast for anyone to install and secure their online communications.</p>
<p>https://az.cokh.net/softether-vpn-server-on-a-nat-server/<br />http://blog.lincoln.hk/blog/2013/03/19/softether-on-vps/</p>
