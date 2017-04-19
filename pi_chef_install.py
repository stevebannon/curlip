#!/usr/bin/python3

import requests
import json
import sys
import re
import os
from subprocess import call

if os.geteuid()!=0:
    print ( 'You need root permissions to perform this operation')
    sys.exit(1)

f = open("/home/pi/elruby_2.3.3-1_armhf.deb", "w")
call(["curl","http://jumphost.el.nist.gov/chef/elruby_2.3.3-1_armhf.deb"], stdout=f)
f.closed

call(["apt-get","-y","remove","ruby"])
call(["dpkg","--install","/home/pi/curlip/files/elruby_2.3.3-1_armhf.deb"])
call(["/opt/elruby/bin/gem","install","chef","--no-ri","--no-rdoc"])
call(["/opt/elruby/bin/gem","install","ruby-shadow","--no-ri","--no-rdoc","-v","12.19.36"])
call(["/opt/elruby/bin/chef-solo","-c","/home/pi/curlip/chef/solo.rb","-j","/home/pi/curlip/chef/solo.json","-L","/var/log/chefinstall.log"])
