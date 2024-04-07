#!/bin/bash

current_date=$(date "+%Y-%m-%d %H:%M:%S")

# 获取 IP 地址
IP=$(/sbin/ifconfig en0 | grep "inet " | awk '{print $2}')


echo "${current_date} - new IP is $IP"

# 将新的 IP 地址写入 hosts 文件
echo "$IP zhaoyanpengdeMacBook-Pro.local" | tee /Users/zhaoyanpeng/tools/dotfiles/docker/remote_hosts/hostsfile/work
