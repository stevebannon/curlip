#!/bin/bash
#

HOSTNAME=`hostname`
SERIAL=`cat /proc/cpuinfo | grep Serial | cut -d ' ' -f 2`
#IPADDR=`ifconfig | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0.1'`
cat <<EOT > mail.txt
From: "Steve Bannon" <steven.bannon@gmail.com>
To: "Steve Bannon" <sbannon@nist.gov>
Subject: IP for $HOSTNAME, serial# $SERIAL

`for i in \`ifconfig | grep -v '^\ \|^$\|lo' | awk '{print $1}'\`; do echo $i \`ifconfig $i | grep HWaddr | awk '{print $5}'\` \`ifconfig $i | grep inet\ addr | awk '{print $2}' | awk -F: '{print $2}'\`; done`
EOT

curl --url 'smtps://smtp.gmail.com:465' --ssl-reqd   --mail-from 'steven.bannon@gmail.com' --mail-rcpt 'sbannon@nist.gov' --upload-file mail.txt --user 'steven.bannon@gmail.com:em2wnwrx' --insecure
