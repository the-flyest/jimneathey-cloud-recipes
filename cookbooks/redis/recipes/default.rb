#
# Cookbook Name:: redis
# Recipe:: default
#

# Upate this
appname = 'yourapp'

# Install Redis on util slice named "redis"
if node[:instance_role] == 'util' && node[:name][/^redis/i]
  execute "set_overcommit_memory" do
    command "echo 1 > /proc/sys/vm/overcommit_memory"
    action :run
  end

  enable_package "dev-db/redis" do
    version "2.2.10"
  end

  package "dev-db/redis" do
    version "2.2.10"
    action :upgrade
  end

  directory "/data/redis" do
    owner 'redis'
    group 'redis'
    mode 0755
    recursive true
    action :create
  end

  template "/etc/redis_util.conf" do
    owner 'root'
    group 'root'
    mode 0644
    source "redis.conf.erb"
    variables({
      :pidfile => '/var/run/redis_util.pid',
      :basedir => '/data/redis',
      :logfile => '/data/redis/redis.log',
      :port => '6379',
      :loglevel => 'notice',
      :timeout => 300000,
    })
  end

  template "/data/monit.d/redis_util.monitrc" do
    owner 'root'
    group 'root'
    mode 0644
    source "redis.monitrc.erb"
    variables({
      :profile => '1',
      :configfile => '/etc/redis_util.conf',
      :pidfile => '/var/run/redis_util.pid',
      :logfile => '/data/redis',
      :port => '6379',
    })
  end

  execute "monit reload" do
    action :run
  end
end

# Write redis.yml 
if ['app_master', 'app', 'util'].include?(node[:instance_role])
  redis_host = node[:utility_instances].select{|i| i[:name][/^redis/i]}[0][:hostname]
  
  run_for_app(appname) do |app_name, data|
    template "/data/#{app_name}/shared/config/redis.yml" do
      owner node[:owner_name]
      group node[:owner_name]
      mode 0644
      backup 0
      source "redis.yml.erb"
      variables({
        :env => node[:environment][:framework_env],
        :host => redis_host,
        :port => '6379'
      })
    end
  end
end