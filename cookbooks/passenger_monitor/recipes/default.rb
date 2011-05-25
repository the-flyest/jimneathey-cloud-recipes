limit = 440320

if ['app_master', 'app', 'solo'].include?(node[:instance_role])
  node[:applications].each do |app_name, data|
    cron "passenger_monitor_#{app_name}" do
      minute '*'
      hour '*'
      day '*'
      weekday '*'
      month '*'
      command "/engineyard/bin/passenger_monitor #{app_name} -f #{app['type']} -l #{limit} >/dev/null 2>&1"
    end
  end
end