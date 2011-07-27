# fix database.yml for mysql2
if ['app_master', 'app', 'util', 'solo'].include?(node[:instance_role])
  execute "fixing database.yml" do
    command "sed -i s/mysql$/mysql2/ /data/shoplove/shared/config/database.yml"
  end
end