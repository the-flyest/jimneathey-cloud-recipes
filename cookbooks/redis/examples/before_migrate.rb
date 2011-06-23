# example deploy hook
on_app_servers_and_utilities do
  run "ln -nfs #{shared_path}/config/redis.yml #{release_path}/config/redis.yml"
end