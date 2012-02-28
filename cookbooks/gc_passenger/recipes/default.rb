if ['app_master', 'app', 'solo'].include?(node[:instance_role])
  template "/usr/local/bin/ruby_wrapper" do
    owner node[:owner_name]
    group node[:owner_name]
    mode 0755
    backup 0
    source "ruby_wrapper.erb"
  end
  
  execute "update passenger_ruby" do
    command 'echo -e "# Overide ruby with wrapper\npassenger_ruby /usr/local/bin/ruby_wrapper;" >> /etc/nginx/http-custom.conf'
    not_if 'grep passenger_ruby /etc/nginx/http-custom.conf'
  end
  
  execute "reload nginx" do
    command '/etc/init.d/nginx reload'
  end
end