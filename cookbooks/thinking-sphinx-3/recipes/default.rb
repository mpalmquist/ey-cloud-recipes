#
# Cookbook Name:: sphinx
# Recipe:: default
#

# if solo? || !db_server?
Chef::Log.info "run sphinx? #{solo?} || #{util?}"
if solo? || util?
  Chef::Log.info "Running thinking-sphinx-3 recipe"
  include_recipe "thinking-sphinx-3::cleanup"
  include_recipe "thinking-sphinx-3::install"
  include_recipe "thinking-sphinx-3::thinking_sphinx"
  include_recipe "thinking-sphinx-3::setup"
end
