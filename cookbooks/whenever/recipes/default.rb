ey_cloud_report "whenever" do
  message "starting whenever recipe"
end

# Set your application name here
appname = "SolarNexus3"

if ['solo', 'app_master'].include?(node[:instance_role])

  # be sure to replace "app_name" with the name of your application.
  local_user = node[:users].first
  execute "whenever" do
    cwd "/data/#{appname}/#{node[:release_path]}"
    user local_user[:username]
    command "bundle exec whenever --update-crontab '#{appname}_#{node[:environment][:framework_env]}'"
    action :run
  end

  ey_cloud_report "whenever" do
    message "whenever recipe complete"
  end
end
