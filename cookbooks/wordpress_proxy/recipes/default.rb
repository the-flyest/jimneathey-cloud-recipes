# update this
app_name = 'willh'
blog_url = 'http://blog.com/'

# write custom.conf
if ['app_master', 'app', 'solo'].include?(node[:instance_role])
  template "/data/nginx/servers/#{app_name}/custom.conf" do
    source 'custom.conf.erb'
    owner 'deploy'
    group 'deploy'
    mode 0644
    backup false
    attributes :blog_url => blog_url
  end
end

# reload nginx
execute "/etc/init.d/nginx reload"