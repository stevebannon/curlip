service 'ssh' do
  supports :status => true, :restart => true, :reload => true
  action [:start, :enable]
end

ruby_block "fix keyboard type" do
	block do
		rc = Chef::Util::FileEdit.new("/etc/default/keyboard")
		rc.search_file_replace_line(
			/^.*XKBMODEL=/,
			'XKBMODEL="pc101"'
		)
		rc.search_file_replace_line(
			/^.*XKBLAYOUT=/,
			'XKBLAYOUT="us"'
		)
		rc.write_file
	end
	ignore_failure true
end

ruby_block "fix keyboard locale" do
	block do
		rc = Chef::Util::FileEdit.new("/etc/default/locale")
		rc.search_file_replace_line(
			/^.*LANG=/,
			'LANG=en_US.UTF-8'
		)
		rc.write_file
	end
	ignore_failure true
end

ruby_block "raspi-config" do
	block do
		rc = Chef::Util::FileEdit.new("/boot/config.txt")
		rc.search_file_replace_line(
			/.*hdmi_force_hotplug/,
			'hdmi_force_hotplug=1'
		)
		rc.write_file
	end
	ignore_failure true
end
