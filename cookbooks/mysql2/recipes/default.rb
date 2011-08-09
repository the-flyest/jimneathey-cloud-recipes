# fix database.yml for mysql2
app_name = 'yourapp'

if ['app_master', 'app', 'util', 'solo'].include?(node[:instance_role])
  execute "fixing database.yml" do
    command "sed -i s/mysql$/mysql2/ /data/#{app_name}/shared/config/database.yml"
  end
end