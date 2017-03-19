include_recipe 'poise-python'

python_package 'graypy'
python_package 'logging'

package 'arpalert' do
  action :install
end

service 'arpalert' do
  supports :status => true, :restart => true, :reload => true
  action [:start, :enable]
end

cookbook_file '/var/lib/arpalert/arpalert' do
  source 'arpalert'
  owner 'root'
  group 'root'
  mode '0755'
  notifies :restart, 'service[arpalert]'
end

ruby_block "set_action_script" do
	block do
		rc = Chef::Util::FileEdit.new("/etc/arpalert/arpalert.conf")
		rc.search_file_replace_line(
			/^.*action\ on\ detect/,
			"action on detect = \"/var/lib/arpalert/arpalert\""
		)
		rc.write_file
	end
end