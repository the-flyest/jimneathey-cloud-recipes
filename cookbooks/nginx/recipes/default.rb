enable_package "www-servers/nginx" do
  version "0.8.54"
end

package "www-servers/nginx" do
  version "0.8.54"
  action :install
end

service "nginx" do
  supports :status => true, :stop => true, :restart => true, :status => true
  action :restart
end
