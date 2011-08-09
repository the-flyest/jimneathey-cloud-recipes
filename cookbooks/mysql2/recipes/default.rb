# fix database.yml for mysql2
if ['app_master', 'app', 'util', 'solo'].include?(node[:instance_role])
  node[:applications].each do |app_name, data| 
    execute "fixing database.yml" do
      command "sed -i s/mysql$/mysql2/ /data/#{app_name}/shared/config/database.yml"
    end
  end
end