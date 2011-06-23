# settings
appname = "content_length_bug"

# find memcached hosts
memcached_hosts = node[:utility_instances].select{|i| i[:name][/^memcache/i]}.map{|i| i[:hostname]}

# update memcached.yml on instances
if ['app_master', 'app', 'util', 'solo'].include?(node[:instance_role])
  run_for_app(appname) do |app_name, data|
    template "/data/#{app_name}/shared/config/memcached.yml" do
      owner node[:owner_name]
      group node[:owner_name]
      mode 0644
      backup 0
      source "memcached.yml.erb"
      variables({
        :hosts => memcached_hosts,
        :app_name => app_name,
        :mem_limit => 64
      })
    end
  end
end

# update util instance
if node[:instance_role] == 'util' && node[:name][/^memcache/i]
  run_for_app(appname) do |app_name, data|
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