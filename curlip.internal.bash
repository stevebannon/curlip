#!/bin/bash
#

HOSTNAME=`hostname`
SERIAL=`cat /proc/cpuinfo | grep Serial | cut -d ' ' -f 2`
#IPADDR=`ifconfig | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0.1'`
cat <<EOT > mail.txt
From: "Steve Bannon" <steven.bannon@gmail.com>
To: "Steve Bannon" <sbannon@nist.gov>
Subject: IP for $HOSTNAME, serial# $SERIAL

`ifconfig -a`
EOT

curl --url 'smtp://mailhost.el.nist.gov:25' --mail-from 'steven.bannon@gmail.com' --mail-rcpt 'sbannon@nist.gov' --upload-file mail.txt --insecure
