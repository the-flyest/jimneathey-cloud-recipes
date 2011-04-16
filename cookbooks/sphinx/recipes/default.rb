#
# Cookbook Name:: sphinx
# Recipe:: default
#

appname = "app_name"
util_name = "sphinx"
sphinx_host = @node['utility_instances'].select{|i| i['name'] == util_name}[0]['hostname']

if ['app_master', 'app', 'util'].include?(node[:instance_role])
  run_for_app(appname) do |app_name, data|
    template "/data/#{app_name}/shared/config/sphinx.yml" do
      owner node[:owner_name]
      group node[:owner_name]
      mode 0644
      backup 0
      source "sphinx.yml.erb"
      variables({
        :sphinx_host => sphinx_host,
        :app_name => app_name,
        :mem_limit => 32,
        :user => node[:owner_name]
      })
    end
  end
end

if node[:instance_role] == 'util' && node[:name] == util_name 
  run_for_app(appname) do |app_name, data|
    # report
    ey_cloud_report "Sphinx" do
      message "upgrading sphinx"
    end

    # upgrade sphinx
    enable_package "app-misc/sphinx" do
      version "1.10_beta"
    end
    
    package "app-misc/sphinx" do
      version "1.10_beta"
      action :upgrade
    end
       
    # report
    ey_cloud_report "Sphinx" do
      message "setting up thinking_sphinx"
    end
    
    # setup directories
    directory "/var/run/sphinx" do
      owner node[:owner_name]
      group node[:owner_name]
      mode 0755
    end

    directory "/var/log/engineyard/sphinx/#{app_name}" do
      recursive true
      owner node[:owner_name]
      group node[:owner_name]
      mode 0755
    end

    directory "/data/#{app_name}/shared/config/sphinx" do
      recursive true
      owner node[:owner_name]
      group node[:owner_name]
      mode 0755
    end

    # setup logrotate
    remote_file "/etc/logrotate.d/sphinx" do
      owner "root"
      group "root"
      mode 0755
      source "sphinx.logrotate"
      backup false
      action :create
    end
    
    # config
    execute "sphinx config" do
      command "bundle exec rake ts:conf"
      user node[:owner_name]
      environment({
        'HOME' => "/home/#{node[:owner_name]}",
        'RAILS_ENV' => node[:environment][:framework_env]
      })
      cwd "/data/#{app_name}/current"
    end

    # index
    execute "thinking_sphinx index" do
      command "bundle exec rake ts:in"
      user node[:owner_name]
      environment({
        'HOME' => "/home/#{node[:owner_name]}",
        'RAILS_ENV' => node[:environment][:framework_env]
      })
      cwd "/data/#{app_name}/current"
    end
    
    # monit
    template "/etc/monit.d/sphinx.#{app_name}.monitrc" do
      source "sphinx.monitrc.erb"
      owner node[:owner_name]
      group node[:owner_name]
      mode 0644
      variables({
        :app_name => app_name,
        :user => node[:owner_name]
      })
    end
    
    execute "monit reload"
    
    # setup cronjob
    cron "sphinx index" do
      action :create
      minute "*/5"
      hour '*'
      day '*'
      month '*'
      weekday '*'
      command "cd /data/#{app_name}/current && RAILS_ENV=#{node[:environment][:framework_env]} bundle exec rake ts:in"
      user node[:owner_name]
    end
  end
end