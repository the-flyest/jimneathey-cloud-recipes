limit = 440320

if ['app_master', 'app', 'solo'].include?(node[:instance_role])
  node[:applications].each do |app_name, data|
    cron "passenger_monitor_#{app_name}" do
      minute '*'
      hour '*'
      day '*'
      weekday '*'
      month '*'
      command "/usr/bin/lockrun --lockfile=/var/run/passenger_monitor_#{app_name}.lockrun -- /bin/bash -c '/engineyard/bin/passenger_monitor #{app_name} -f #{data['type']} -l #{limit}  >/dev/null 2>&1'"
    end
  end
end