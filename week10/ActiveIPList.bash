#!/bin/bash

if [ $# -eq 0 ]; then
    echo "Usage: ActiveIPList.bash <Prefix>"
    exit 1
fi

prefix=$1

if [ ${#prefix} -lt 5 ]; then
    printf "Prefix length is too short\nPrefix example: 10.0.17\n"
    exit 1
fi

for i in $(seq 1 254)
do
    ping -c 1 $prefix.$i | grep "64 bytes" | grep -oE "([0-9]+\.){3}[0-9]+"
done
