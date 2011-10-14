# variables
app_name = "yourapp"
repository = "git@github.com:user/yourapp.git"
directory = "/data/yourapp"

# do not edit these
deploy_key = "/home/#{node[:owner_name]}/.ssh/#{app_name}-deploy-key"
ssh_config = "/home/#{node[:owner_name]}/#{app_name}-git-ssh-config"
ssh_wrapper = "/home/#{node[:owner_name]}/#{app_name}-git-ssh"

if ['app_master', 'app', 'util', 'solo'].include?(node[:instance_role])
  # write deploy key
  remote_file deploy_key do
    source "deploy_key"
    owner node[:owner_name]
    group node[:owner_name]
    mode 0600
    backup false
    action :create
    not_if "test -f #{deploy_key}"
  end

  # write git ssh config
  template ssh_config do
    source "git-ssh-config.erb"
    owner node[:owner_name]
    group node[:owner_name]
    mode 0600
    variables({
      :deploy_key => deploy_key,
    })
    not_if "test -f #{ssh_config}"
  end

  # write git ssh wrapper 
  template ssh_wrapper do
    source "git-ssh.erb"
    owner node[:owner_name]
    group node[:owner_name]
    mode 0700
    variables({
      :config_file => ssh_config,
    })
    not_if "test -f #{ssh_wrapper}"
  end

  # clone
  execute "clone app from git" do
    command "git clone #{repository} #{directory}"
    environment({ 
      'GIT_SSH' => ssh_wrapper
    })
    user node[:owner_name]
    group node[:owner_name]
    not_if "test -d #{directory}"
  end
end