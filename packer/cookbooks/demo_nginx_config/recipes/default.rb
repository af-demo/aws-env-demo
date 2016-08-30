#
# Cookbook Name:: demo_nginx_config
# Recipe:: default
#
# Copyright (c) 2016 Alex Fomin, All Rights Reserved.
execute 'yum-makecache' do
  command 'yum -q makecache'
  action :run
end

package ['nginx', 'ruby-devel', 'make', 'gcc']

%w[io-console inspec].each do |gem|
  gem_package gem do
    action :install
  end
end

service 'nginx' do
  action [:enable, :start]
end

template '/usr/share/nginx/html/index.html' do
	source 'index.html.erb'
	mode 0644
	owner "root"
	group "root"
	variables ({
	:TV_page_title => node['demoenv']['pagetitle'],
  :TV_page_text => node['demoenv']['pagetext']
	})
  notifies :reload, 'service[nginx]', :immediately
end

template '/tmp/inspec_tests.rb' do
	source 'inspec_tests.rb.erb'
	mode 0644
	owner "root"
	group "root"
	variables ({
	:TV_page_title => node['demoenv']['pagetitle'],
  :TV_page_text => node['demoenv']['pagetext']
	})
end
