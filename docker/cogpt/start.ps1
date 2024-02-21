New-NetFirewallRule -DisplayName "NextChat" -Direction Inbound -LocalPort 3000 -Protocol TCP -Action Allow
# connectionaddress 为wsl的ip地址
netsh interface portproxy add v4tov4 listenport=3000 listenaddress=0.0.0.0 connectport=3000 connectaddress=172.19.74.172
