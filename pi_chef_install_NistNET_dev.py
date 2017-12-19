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

if ( len(sys.argv) != 2 ):
    print ( 'Incorrect number of arguments', file=sys.stderr )
    print ( 'Usage:', sys.argv[0], '<hostname>', file=sys.stderr )
    sys.exit(1)

hostname = sys.argv[1].lower()

if ( hostname.find('.')!=-1 ):
    print ("shortname required")
    hostname = hostname.split('.',1)[0]
    print ("using",hostname,"as hostname")

print ( hostname )

call(["hostname",hostname])

os.makedirs("/etc/chef", exist_ok=True)

f = open("/etc/chef/client.rb", "w")
f.write("log_level :info\n")
f.write("log_location '/var/log/chefclient.log'\n")
f.write("node_name '")
f.write(hostname)
f.write(".el.nist.gov")
f.write("'\n")
f.write("chef_server_url 'https://chefdev.el.nist.gov'\n")
f.write("validation_client_name 'chef-validator'\n")
f.write("ssl_verify_mode :verify_none\n")
f.closed

f = open("/etc/chef/validation.pem", "w")
call(["curl","http://jumphost.el.nist.gov/chef/validation.pem.dev"], stdout=f)
f.closed

f = open("/tmp/ruby_2.3.3_armhf.deb", "w")
call(["curl","http://ftp.us.debian.org/debian/pool/main/r/ruby-defaults/ruby_2.3.3_armhf.deb"], stdout=f)
f.closed

f = open("/tmp/ruby_2.3.3_armhf.deb", "w")
call(["curl","http://ftp.us.debian.org/debian/pool/main/r/ruby-defaults/ruby_2.3.3_armhf.deb"], stdout=f)
f.closed

call(["apt-get","-y","remove","ruby"])
call(["dpkg","--install","/tmp/ruby_2.3.3_armhf.deb"])
call(["dpkg","--install","/tmp/ruby-dev_2.3.3_armhf.deb"])
call(["apt-get","-f","-y","install"])
call(["/opt/elruby/bin/gem","install","chef","--no-ri","--no-rdoc","-v","12.19.36"])
call(["/opt/elruby/bin/gem","install","ruby-shadow","--no-ri","--no-rdoc"])

call(['/opt/elruby/bin/chef-client','-r','role[pi]'])
