#!/bin/bash
# as root use "nano /root/softetherlogpurge.sh" to create file and save the contents of this into it
# then execute "chmod +x /root/softetherlogpurge.sh" to make it executable
# "crontab -e" to add the line "* * * * * /root/softetherlogpurge.sh >/dev/null 2>&1" to setup all .logs for SofEther to be purged every minute.

# Script to Purge SoftEther Log
# Copyleft (C) 2018 WhatTheServer - All Rights Reserved
# Permission to copy and modify is granted under the CopyLeft license
# Last revised 6/6/2018

#Ensure packet logs are cleared if they ever get enabled
#truncate -s 0 /usr/local/vpnserver/packet_log/**/*.log


#Ensure security logs are cleared if they ever get enabled
#truncate -s 0 /usr/local/vpnserver/security_log/**/*.log

#Ensure softether server logs are cleared if they ever get enabled
#truncate -s 0 /usr/local/vpnserver/server_log/*.log

#Delete softether empty log file names
find /usr/local/vpnserver/ -name '*.log' -delete

#Delete dnsmasq dhcp log
> /var/log/dnsmasq.log