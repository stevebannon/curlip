if (node['platform'] == "centos") && (node['platform_version'].start_with?("7"))
	default['collectd']['basedir'] = "/etc"
	default['collectd']['confdir'] = "/etc/collectd.d"
	default['collectd']['plugindir'] = "/etc/collectd.plugins"
else
	default['collectd']['basedir'] = "/etc/collectd"
	default['collectd']['confdir'] = "/etc/collectd/collectd.conf.d"
	default['collectd']['plugindir'] = "/etc/collectd/plugins"
end

default['collectd']['ipmi'] = ""
default['collectd']['server'] = "localhost"