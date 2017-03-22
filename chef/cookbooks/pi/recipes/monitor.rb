cookbook_file '/tmp/sensu_0.26.3-1_armhf.deb' do
  source 'sensu_0.26.3-1_armhf.deb'
  owner 'root'
  group 'root'
  mode '0644'
  not_if { ::File.exist?('/opt/sensu/bin/sensu-client') }
end

dpkg_package "sensu" do
	package_name "sensu"
	source "/tmp/sensu_0.26.3-1_armhf.deb"
	action :install
	not_if { ::File.exist?('/opt/sensu/bin/sensu-client') }
end

directory '/etc/sensu/ssl' do
  owner 'root'
  group 'root'
  mode '0755'
  action :create
end

directory '/etc/sensu/conf.d' do
  owner 'root'
  group 'root'
  mode '0755'
  action :create
end

remote_directory '/etc/sensu/ssl' do
  source 'sensu/ssl'
  files_owner 'root'
  files_group 'root'
  files_mode '0644'
  owner 'root'
  group 'root'
  mode '0755'
  notifies :restart, 'service[sensu-client]'
end

template '/etc/sensu/conf.d/client.json' do
  source 'sensu/client.json.erb'
  owner 'root'
  group 'root'
  mode '0644'
  notifies :restart, 'service[sensu-client]'
end

template '/etc/sensu/conf.d/rabbitmq.json' do
  source 'sensu/rabbitmq.json.erb'
  owner 'root'
  group 'root'
  mode '0644'
  notifies :restart, 'service[sensu-client]'
end

template '/etc/sensu/conf.d/transport.json' do
  source 'sensu/transport.json.erb'
  owner 'root'
  group 'root'
  mode '0644'
  notifies :restart, 'service[sensu-client]'
end

service 'sensu-client' do
  supports :status => true, :restart => true, :reload => true
  action [:start, :enable]
end
