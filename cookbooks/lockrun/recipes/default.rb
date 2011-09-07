# grab latest source
remote_file '/tmp/lockrun.c' do
  source 'http://www.unixwiz.net/tools/lockrun.c'
  mode '0644'
  owner 'root'
  group 'root'
  backup false
  action :create_if_missing
end

# stop cron
service "vixie-cron" do
  action :stop
end

# compile
bash 'compiling lockrun' do
  cwd '/tmp'
  user 'root'
  code <<-EOF
    gcc lockrun.c -o lockrun
    cp lockrun /usr/bin/
  EOF
end

# cron_nanny should automatically restart cron