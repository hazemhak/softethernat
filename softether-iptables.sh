#!/bin/sh
##########################################################################################################################################
### Configuration
#############################

#DAEMON=/usr/local/vpnserver/vpnserver           # Change this only if you have installed the vpnserver to an alternate location.
#LOCK=/var/lock/vpnserver                        # No need to edit this.
TAP_ADDR=192.168.30.1                              # Main IP of your TAP interface
TAP_INTERFACE=tap_soft                     # The name of your TAP interface.
VPN_SUBNET=192.168.30.0/24                         # Virtual IP subnet you want to use within your VPN
#NET_INTERFACE=ens3                              # Your network adapter that connects you to the world.In OpenVZ this is venet0 for example.
shopt -s extglob; NET_INTERFACE=$(ip link | awk -F: '$0 !~ "lo|vir|wl|tap_soft|^[^0-9]"{print $2;getline}'); NET_INTERFACE="${NET_INTERFACE##*( )}"; shopt -u extglob;
#IPV6_ADDR=2t00:1ba7:001b:0007:0000:0000:0000:0001      # You can also assign this as DNS server in dnsmasq config.
#IPV6_SUBNET=2t00:1ba7:1b:7::/64               # Used to assign IPv6 to connecting clients. Remember to use the same subnet in dnsmasq.conf
#YOUREXTERNALIP=1.2.3.4                  # Your machines external IPv4 address. 
YOUREXTERNALIP=$(hostname -I | cut -d ' ' -f 1)                                                # Write down you IP or one of the IP adresses if you have more than one.
                                                # Warning! NAT Machine users, here write the local IP address of your VPS instead of the external IP.

#############################
### End of Configuration
##########################################################################################################################################

#Flush Current rules
iptables -F && iptables -X
#######################################################################################
#	Rules for IPTables. You can remove and use these iptables-persistent if you want 
#######################################################################################
# Assign $TAP_ADDR to our tap interface
/sbin/ifconfig $TAP_INTERFACE $TAP_ADDR
#
# Forward all VPN traffic that comes from VPN_SUBNET through $NET_INTERFACE interface for outgoing packets.
iptables -t nat -A POSTROUTING -s $VPN_SUBNET -j SNAT --to-source $YOUREXTERNALIP
# Alternate rule if your server has dynamic IP
#iptables -t nat -A POSTROUTING -s $VPN_SUBNET -o $NET_INTERFACE -j MASQUERADE
#
# Allow VPN Interface to access the whole world, back and forth.
iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -A OUTPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -A FORWARD -m state --state ESTABLISHED,RELATED -j ACCEPT
# 
iptables -A INPUT -s $VPN_SUBNET -m state --state NEW -j ACCEPT 
iptables -A OUTPUT -s $VPN_SUBNET -m state --state NEW -j ACCEPT 
iptables -A FORWARD -s $VPN_SUBNET -m state --state NEW -j ACCEPT 
# 
# IPv6
# This is the IP we use to reply DNS requests.
#ifconfig $TAP_INTERFACE inet6 add $IPV6_ADDR
#
# Without assigning the whole /64 subnet, Softether doesn't give connecting clients IPv6 addresses.
#ifconfig $TAP_INTERFACE inet6 add $IPV6_SUBNET
#
# Let's define forwarding rules for IPv6 as well...
#ip6tables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
#ip6tables -A FORWARD -m state --state ESTABLISHED,RELATED -j ACCEPT
#ip6tables -A OUTPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
#ip6tables -A FORWARD -j ACCEPT
#ip6tables -A INPUT -j ACCEPT
#ip6tables -A OUTPUT -j ACCEPT

# You can enable this for kernels 3.13 and up
#ip6tables -t nat -A POSTROUTING -o tap_soft -j MASQUERADE
#######################################################################################
#	End of IPTables Rules
#######################################################################################
