#!/bin/bash
IP=$(ip addr show tun0 2>/dev/null | grep "inet " | awk '{print $2}' | cut -d/ -f1)

if [ -z "$IP" ]; then
    echo "#[fg=red]❌ Offline"
else
    echo "#[fg=green]🔒 $IP"
fi
