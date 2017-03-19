if node.recipes.include?('el_collectd::default')

	package 'python-ceph' do
	  action :install
	end

	directory '/usr/lib/collectd/plugins/' do
	  owner 'root'
	  group 'root'
	  mode '0755'
	  action :create
	end

	directory '/usr/lib/collectd/plugins/ceph' do
	  owner 'root'
	  group 'root'
	  mode '0755'
	  action :create
	end

	cookbook_file '/usr/lib/collectd/plugins/ceph/collectd-ceph.py' do
	  source 'collectd-ceph.py'
	  owner 'root'
	  group 'root'
	  mode '0644'
	  notifies :restart, 'service[collectd]'
	end
	
	cookbook_file "#{node['collectd']['confdir']}/ceph.conf" do
	  source 'ceph.conf'
	  owner 'root'
	  group 'root'
	  mode '0644'
	  notifies :restart, 'service[collectd]'
	end

else
	log 'el_collectd::default recipe is required'
end
