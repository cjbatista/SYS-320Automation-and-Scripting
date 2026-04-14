#!/bin/bash

# List all the ips in the given network prefix
# /24 only
# Usage: bash IPList.bash <Prefix>

if [ $# -eq 0 ]; then
    echo "Usage: IPList.bash <Prefix>"
    exit 1
fi

prefix=$1

for i in $(seq 1 254)
do
    echo "$prefix.$i"
done
