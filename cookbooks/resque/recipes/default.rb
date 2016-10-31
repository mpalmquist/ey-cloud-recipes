#
# Cookbook Name:: resque
# Recipe:: default
#
if ['solo', 'redis'].include?(node[:instance_role])
  execute "install resque gem" do
    command "gem install resque redis redis-namespace yajl-ruby -r"
    not_if { "gem list | grep resque" }
  end

  worker_count = 6

  # case node[:ec2][:instance_type]
  # when 'm1.small' then worker_count = 2
  # when 'c1.medium'then worker_count = 3
  # when 'c1.xlarge' then worker_count = 8
  # else worker_count = 4
  # end

  node[:applications].each do |app, data|
    template "/etc/monit.d/resque_#{app}.monitrc" do
      owner 'root'
      group 'root'
      mode 0644
      source "monitrc.conf.erb"
      variables({
      :num_workers => worker_count,
      :app_name => app,
      :rails_env => node[:environment][:framework_env]
      })
    end

    template "/data/#{app}/shared/config/resque_0.conf" do
      owner node[:owner_name]
      group node[:owner_name]
      mode 0644
      source 'resque_short_tasks_1.conf.erb'
    end

    template "/data/#{app}/shared/config/resque_1.conf" do
      owner node[:owner_name]
      group node[:owner_name]
      mode 0644
      source 'resque_short_tasks_2.conf.erb'
    end

    template "/data/#{app}/shared/config/resque_2.conf" do
      owner node[:owner_name]
      group node[:owner_name]
      mode 0644
      source 'resque_long_no_parallel_execution.conf.erb'
    end

    template "/data/#{app}/shared/config/resque_3.conf" do
      owner node[:owner_name]
      group node[:owner_name]
      mode 0644
      source 'resque_pv_watts.conf.erb'
    end

    template "/data/#{app}/shared/config/resque_4.conf" do
      owner node[:owner_name]
      group node[:owner_name]
      mode 0644
      source 'resque_urgent_tasks.conf.erb'
    end

    template "/data/#{app}/shared/config/resque_5.conf" do
      owner node[:owner_name]
      group node[:owner_name]
      mode 0644
      source 'resque_urgent_tasks.conf.erb'
    end

    execute "ensure-resque-is-setup-with-monit" do
      epic_fail true
      command %Q{
      monit reload
      }
    end
  end
end
