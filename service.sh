#!/system/bin/sh

# Wait for networking to be ready
while [ "$(getprop sys.boot_completed)" != "1" ]; do sleep 1; done
iptables -D INPUT -p tcp --dport 5555 -j DROP
iptables -I INPUT -p tcp --dport 5555 -j DROP

# Wait for tun0
while ! ip link show tun0 >/dev/null 2>&1; do sleep 1; done
iptables -D INPUT -i tun0 -p tcp --dport 5555 -j ACCEPT
iptables -I INPUT 1 -i tun0 -p tcp --dport 5555 -j ACCEPT

# Open ADB over port 5555
setprop service.adb.tcp.port 5555
stop adbd
sleep 1
start adbd
