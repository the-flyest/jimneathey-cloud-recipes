if ['app_master', 'app', 'util', 'solo'].include?(node[:instance_role])
  run_for_app(appname) do |app_name, data|
    template "/data/#{app_name}/shared/config/redis.yml" do
      owner node[:owner_name]
      group node[:owner_name]
      mode 0644
      backup 0
      source "redis.yml.erb"
      variables({
        :env => node[:environment][:framework_env],
        :host => node[:db_host],
        :port => 6379
      })
    end
  end
end