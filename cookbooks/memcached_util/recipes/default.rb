#
# Cookbook Name:: memcached_util
# Recipe:: default
#

# settings
appname = "app_name"
util_name = "memcached"

# find memcached util hostname
memcached_host = @node['utility_instances'].select{|i| i['name'] == util_name}[0]['hostname']

# update memcached.yml on instances
if ['app_master', 'app', 'util'].include?(node[:instance_role])
  run_for_app(appname) do |app_name, data|
    template "/data/#{app_name}/shared/config/memcached.yml" do
      owner node[:owner_name]
      group node[:owner_name]
      mode 0644
      backup 0
      source "memcached.yml.erb"
      variables({
        :memcached_host => memcached_host,
        :app_name => app_name,
        :mem_limit => 64
      })
    end
  end
end

# update util instance
if node[:instance_role] == 'util' && node[:name] == util_name
  run_for_app(appname) do |app_name, data|
    # report
    ey_cloud_report "Memcached" do
      message "upgrading memcached"
    end

    # upgrade sphinx
    enable_package "net-misc/memcached" do
      version "1.4.5"
    end
    
    package "net-misc/memcached" do
      version "1.4.5"
      action :upgrade
    end
    
    # monit
    remote_file "/etc/monit.d/memcached.monitrc" do
      owner "root"
      group "root"
      mode 0755
      source "memcached.monitrc"
      backup false
      action :create
    end
    
    execute "monit reload"
  end
end