#!/bin/bash
url="http://10.0.17.6/IOC.html"
curl -s "$url" | grep -oP '(?<=<td>).*?(?=</td>)' | awk 'NR%2==1' > IOC.txt
echo "IOC saved to IOC.txt"
cat IOC.txt
