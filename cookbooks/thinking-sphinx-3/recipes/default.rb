#
# Cookbook Name:: sphinx
# Recipe:: default
#
if solo? || util?
  Chef::Log.info "Running thinking-sphinx-3 recipe"
  include_recipe "thinking-sphinx-3::install"
  include_recipe "thinking-sphinx-3::setup"
else
  include_recipe "thinking-sphinx-3::cleanup"
end
unless db_server?
  include_recipe "thinking-sphinx-3::thinking_sphinx"
end
