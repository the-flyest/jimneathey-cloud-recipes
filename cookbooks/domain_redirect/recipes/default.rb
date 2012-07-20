#
# Cookbook Name:: domain_redirect
# Recipe:: default
#

# variables
app_name = 'yourappname'
domain_name = 'example.com' # without www. prefix

# write custom config
if ['app_master', 'app', 'solo'].include?(node[:instance_role]) 
  template "/data/nginx/servers/#{app_name}/custom.conf" do
    source 'custom.conf.erb'
    owner 'deploy'
    group 'deploy'
    mode 0644
    backup false
    variables({
      :domain_name => domain_name
    })
  end
  
  execute '/etc/init.d/nginx reload' do
    action :run
  end
end