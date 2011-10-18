app_name = 'yourapp'

if ['app_master', 'app', 'util', 'solo'].include?(node[:instance_role])
  template "/data/#{app_name}/shared/config/resque.yml" do
    owner node[:owner_name]
    group node[:owner_name]
    mode 0644
    backup 0
    source "resque.yml.erb"
    variables({
      :env => node[:environment][:framework_env],
      :host => node[:db_host],
      :port => '6379'
    })
  end
end