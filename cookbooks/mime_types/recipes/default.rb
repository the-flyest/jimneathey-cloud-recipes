if ['solo', 'app_master', 'app'].include?(node[:instance_role])
  # copy mime.types file
  remote_file "/etc/nginx/mime.types" do
    owner node[:owner_name]
    group node[:owner_name]
    mode 0755
    source "mime.types"
    backup false
    action :create
  end
  
  # reload nginx
  service "nginx" do
    supports :reload => true
    action :reload
  end
end