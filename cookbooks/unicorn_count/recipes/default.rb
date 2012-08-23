#
# Cookbook Name:: unicorn_count
# Recipe:: default
#

# variables
app_name = "dev3dynamic"
worker_count = 10

if ['app_master', 'app', 'solo'].include?(node[:role])
  # update monit config
  template "/etc/monit.d/delayed_job#{count+1}.#{app_name}.monitrc" do
    owner 'root'
    group 'root'
    mode 0644
    source "unicorn.monitrc.erb"
    backup 0
    variables({
      :user => node['engineyard']['environment']['ssh_username'],
      :app_name => app_name,
      :worker_count => worker_count
    })
  end
  
  # restart monit
  execute "restart-monit" do
    command "monit quit "
  end
  
  # update unicorn.rb
  execute "update-unicorn-rb" do
  	command "sed -i -r -e 's/(worker_processes) [0-9]+/\1 #{worker_count}/' /data/#{app_name}/shared/config/unicorn.rb"
  end
  
  # restart unicorn master
  execute "restart-unicorn-master" do
    command "monit restart unicorn_master_#{app_name}"
  end
end
