#
# Cookbook Name:: ban
# Recipe:: default
#

ban('EasouSpider') do
  ip "183.60.0.0/16"
end

ban('bad french') do
  ip "188.165.12.96"
end


