# edit this
app_name = 'yourappname'

# create log directory
directory '/var/log/newrelic' do
  action :create
  owner 'root'
  not_if 'test -d /var/log/newrelic'
end

directory '/etc/newrelic' do
  action :create
  owner 'root'
  not_if 'test -d /etc/newrelic'
end

# copy files
architecture = ['m1.small', 'c1.medium'].include?(node[:ec2][:instance_type]) ? 'x86' : 'x64'

remote_file '/usr/local/sbin/nrsysmond' do
  action :create_if_missing
  source "nrsysmond.#{architecture}"
  owner 'root'
  group 'root'
end

remote_file '/usr/local/sbin/nrsysmond-config' do
  action :create_if_missing
  source 'nrsysmond-config'
  owner 'root'
  group 'root'
end

remote_file '/etc/newrelic/nrsysmond.cfg' do
  action :create_if_missing
  source 'nrsysmond.cfg'
  mode '0600'
  owner 'root'
  group 'root'
end

remote_file '/etc/init.d/nrsysmond' do
  action :create_if_missing
  source 'nrsysmond.init'
  mode '0755'
  owner 'root'
  group 'root'
end

# setup license key
execute "update new relic license key" do
  command "/usr/local/sbin/nrsysmond-config --set license_key=`grep license_key /data/#{app_name}/shared/config/newrelic.yml | awk '{print $NF}'`"
end

# start nrsysmond
execute "start nrsysmond" do
  command "/etc/init.d/nrsysmond start"
  not_if "ps aux | grep nrsysmond | grep -v grep"
end