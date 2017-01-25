require 'pp'
#
# Cookbook Name:: memcached
# Recipe:: default
#

execute "reload-monit" do
  command "monit quit && telinit q"
  action :nothing
end

node[:applications].each do |app_name,data|
  user = node[:users].first
  if %w(solo app app_master util).include? node[:instance_role]
    template("/data/#{app_name}/shared/config/memcached_custom.yml") do
      source "memcached.yml.erb"
      owner user[:username]
      group user[:username]
      mode 0744
      variables({:app_name => app_name,:server_names => node[:members] })
    end
  end

  if %w(solo util).include? node[:instance_role]
    template "/etc/conf.d/memcached" do
      owner 'root'
      group 'root'
      mode 0644
      source "memcached.erb"
      variables :memusage => 64, :port => 11211
    end
  else
    file "/etc/monit.d/memcached.monitrc" do
      action :delete
      notifies :run, resources(:execute => "reload-monit")
      only_if "test -f /etc/monit.d/memcached.monitrc"
    end
    execute "kill-memcached" do
      command "pkill -f memcached"
      only_if "pgrep -f memcached"
    end
  end
end
