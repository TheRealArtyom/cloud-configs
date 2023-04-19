#!/bin/bash

date=$(date '+%d-%m-%Y')
time=$(date '+%H:%M:%S')
prefix="[$date] [$time] [SQUID-CACHE-CLEARER]:"

echo "$prefix STARTED"

echo "$prefix stopping squid proxy-server..."
systemctl stop squid.service
echo "$prefix stopped squid proxy-server."

echo "$prefix deleting squid proxy-server cache..."
rm -rf /var/spool/squid/* 
echo "$prefix squid proxy-server cache deleted."

echo "$prefix starting squid proxy-server..."
systemctl start squid.service
echo "$prefix squid proxy-server started." 

echo "$prefix DONE"
