#
# Cookbook Name:: collectd
# Recipe:: default
#
# Copyright (C) 2015 YOUR_NAME
#
# All rights reserved - Do Not Redistribute
#

case node['platform']
when 'ubuntu'
	include_recipe 'apt::default'
when 'raspbian'
  include_recipe 'apt::default'
when 'centos'
	include_recipe 'yum-epel::default'
end

package 'collectd' do
	action :install
end

package 'collectd-utils' do
	action :install
	only_if { node['platform'].start_with?("ubuntu") }
end

package 'collectd-rrdtool' do
  action :install
  only_if { node['platform'].start_with?("centos") }
end

package 'collectd-ipmi' do
  action :install
  only_if { node['platform'].start_with?("centos") }
end

directory node['collectd']['basedir'] do
  owner 'root'
  group 'root'
  mode '0755'
  action :create
end

directory node['collectd']['confdir'] do
  owner 'root'
  group 'root'
  mode '0755'
  action :create
end


template "#{node['collectd']['basedir']}/collectd.conf" do
	source 'collectd.conf.erb'
	owner 'root'
	group 'root'
	mode '0644'
	notifies :restart, 'service[collectd]'
end

directory node['collectd']['plugindir'] do
  owner 'root'
  group 'root'
  mode '0755'
  action :create
end

template "#{node['collectd']['confdir']}/cpu_info.conf" do
  source 'cpu_info.conf.erb'
  owner 'root'
  group 'root'
  mode '0644'
  notifies :restart, 'service[collectd]'
end

cookbook_file "#{node['collectd']['plugindir']}/cpu_info.py" do
  source 'cpu_info.py'
  owner 'root'
  group 'root'
  mode '0755'
  notifies :restart, 'service[collectd]'
end

cookbook_file "#{node['collectd']['confdir']}/ipmi.conf" do
  source 'ipmi.conf'
  owner 'root'
  group 'root'
  mode '0644'
  only_if { node['collectd']['ipmi'].start_with?("true") }
end

service 'collectd' do
	supports :status => true, :restart => true, :reload => true
	action [ :start, :enable ]
end

cron 'restart_collectd' do
  hour '3'
  minute '0'
  command 'service collectd restart > /dev/null'
  path '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin'
end
