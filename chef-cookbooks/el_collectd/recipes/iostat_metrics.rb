if node.recipes.include?('el_collectd::default')

	package 'sysstat' do
	  action :install
	end

	directory '/usr/lib/collectd/plugins' do
	  owner 'root'
	  group 'root'
	  mode '0755'
	  action :create
	end

	directory '/usr/lib/collectd/plugins/iostat' do
	  owner 'root'
	  group 'root'
	  mode '0755'
	  action :create
	end

	cookbook_file '/usr/lib/collectd/plugins/iostat/collectd_iostat_python.py' do
	  source 'collectd_iostat_python.py'
	  owner 'root'
	  group 'root'
	  mode '0644'
	  notifies :restart, 'service[collectd]'
	end

	cookbook_file "#{node['collectd']['confdir']}/iostat.conf" do
	  source 'iostat.conf'
	  owner 'root'
	  group 'root'
	  mode '0644'
	  notifies :restart, 'service[collectd]'
	end
else
	log 'el_collectd::default recipe is required'
end