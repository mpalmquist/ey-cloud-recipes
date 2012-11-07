# default memory limit is = 250

memory_limit = 400

ey_cloud_report "passenger_monitor_memory_limit" do
  message "passenger_monitor memory limit set to #{memory_limit}MB"
end

node["engineyard"]["environment"]["apps"].each do |app|
  app_name = app["name"]
  cron "passenger_monitor_#{app_name}" do
    minute '*'
    hour '*'
    day '*'
    weekday '*'
    month '*'
    command "/usr/bin/lockrun --lockfile=/var/run/passenger_monitor_#{app_name}.lockrun -- /bin/bash -c '/engineyard/bin/passenger_monitor #{app_name} -l #{memory_limit} >/dev/null 2>&1'"
  end
end
