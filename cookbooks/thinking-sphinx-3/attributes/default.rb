#
# Cookbook Name:: sphinx
# Attrbutes:: default
#

instances = node[:engineyard][:environment][:instances]
default[:sphinx] = {
  # Sphinx will be installed on to application/solo instances,
  # unless a utility name is set, in which case, Sphinx will
  # only be installed on to a utility instance that matches
  # the name
  :utility_name => if instances.size == 1
                     'solo'
                   elsif instances.size == 2
                     'app_master'
                   else
                     node[:engineyard][:environment][:utility_instances].first[:name]
                   end,
  # The version of sphinx to install
  :version => '2.0.8',

  # Applications that are using sphinx. Leave this blank to
  # setup sphinx for each app in an environment
  # :apps => ['todo', 'admin'],
  :apps => [],

  # Index frequency. How often the indexer cron job should
  # be run. A value of 15 will reindex every 15 minutes
  :frequency => 20
}

# Note: You do not need to edit below this line

# Store sphinx node as attribute
util = instances.find{|i| i[:name].to_s == default[:sphinx][:utility_name]}
Chef::Log.info "SPHINX INSTANCE: #{util.inspect}"

default[:sphinx][:host] = util ? util[:private_hostname] : '127.0.0.1'
Chef::Log.info "SPHINX HOST: #{default[:sphinx][:host]}"

# Set apps key to all available apps if empty
if default[:sphinx][:apps].empty?
  default[:sphinx][:apps] = node[:engineyard][:environment][:apps].map{|a| a[:name]}
end
