#
# Cookbook Name:: juggernaut_ssl
# Recipe:: default
#

app_name = 'reza'
app = node[:engineyard][:environment][:apps].find{|a| a[:name] == 'pssurvey'}
ssl = app[:vhosts][0][:ssl_cert]

if node[:instance_role] == 'util' && node[:name] == 'juggernaut'
  template "/usr/lib/node_modules/juggernaut/lib/juggernaut/keys/privatekey.pem" do
    owner node[:owner_name]
    group node[:owner_name]
    mode 0644
    source "ssl.key.erb"
    backup 0
    variables(
      :key => ssl[:private_key]
    )
  end

  template "/usr/lib/node_modules/juggernaut/lib/juggernaut/keys/certificate.pem" do
    owner node[:owner_name]
    group node[:owner_name]
    mode 0644
    source "ssl.crt.erb"
    backup 0
    variables(
      :crt => ssl[:certificate],
      :chain => ssl[:certificate_chain]
    )
  end
end