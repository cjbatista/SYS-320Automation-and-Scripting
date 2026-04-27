#!/bin/bash

# Get just the first IP address (in case there are multiple)
myIP=$(bash myIP.bash | head -n 1)

# Todo-1: Help menu function
function helpmenu(){
    echo "HELP MENU"
    echo "-n: Add -n as an argument for this script to use nmap"
    echo "    -n external: External NMAP scan"
    echo "    -n internal: Internal NMAP scan"
    echo "-s: Add -s as an argument for this script to use ss"
    echo "    -s external: External ss(Netstat) scan"
    echo "    -s internal: Internal ss(Netstat) scan"
    echo "Usage: bash networkchecker.bash -n/-s external/internal"
}

# Return ports that are serving to the network
function ExternalNmap(){
    rex=$(nmap "${myIP}" | awk -F"[/[:space:]]+" '/open/ {print $1,$4}')
    echo "$rex"
}

# Return ports that are serving to localhost
function InternalNmap(){
    rin=$(nmap localhost | awk -F"[/[:space:]]+" '/open/ {print $1,$4}')
    echo "$rin"
}

# Todo-2: Only IPv4 ports listening from network
function ExternalListeningPorts(){
    elpo=$(ss -ltpn | awk -F"[[:space:]:(),]+" '/0.0.0.0/ {print $5,$9}' | tr -d "\"")
    echo "$elpo"
}

# Only IPv4 ports listening from localhost
function InternalListeningPorts(){
    ilpo=$(ss -ltpn | awk -F"[[:space:]:(),]+" '/127.0.0./ {print $5,$9}' | tr -d "\"")
    echo "$ilpo"
}

# Todo-3: If the program is not taking exactly 2 arguments, print helpmenu
if [ $# -ne 2 ]; then
    helpmenu
    exit 1
fi

# Todo-4: Use getopts to accept options -n and -s
while getopts "n:s:" opt
do
    case "$opt" in
        n)
            if [ "$OPTARG" == "external" ]; then
                ExternalNmap
            elif [ "$OPTARG" == "internal" ]; then
                InternalNmap
            else
                helpmenu
            fi
            ;;
        s)
            if [ "$OPTARG" == "external" ]; then
                ExternalListeningPorts
            elif [ "$OPTARG" == "internal" ]; then
                InternalListeningPorts
            else
                helpmenu
            fi
            ;;
        *)
            helpmenu
            ;;
    esac
done
