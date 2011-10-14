app_name = 'yourapp'
directory = "/data/yourapp"

on_app_servers_and_utilities do
  run "cd #{directory} && GIT_SSH=/home/#{user}/#{app_name}-git-ssh git pull origin master"
end