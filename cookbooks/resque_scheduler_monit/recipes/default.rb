#
# Cookbook Name:: resque_scheduler_monit
# Recipe:: default
#

app_name = "betdash"

if ['app_master', 'solo'].include?(node[:instance_role])
  # write monitrc
  template "/data/monit.d/resque_scheduler.monitrc" do
    owner node[:owner_name]
    group node[:owner_name]
    mode 0644
    backup 0
    source "resque_scheduler.monitrc.erb"
    variables({
      :app_name => app_name,
      :pidfile => "/var/run/resque_scheduler.pid",
      :env => node[:environment][:framework_env]
    })
  end
  
  # reload monit
  execute "monit reload"
end