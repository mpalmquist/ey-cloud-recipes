#############################################
# Sample recipe for emerging packages
#
# Search the Engine Yard portage tree to find
# out package versions to install
#
# EXAMPLE:
#
# Ensure local package index is synced with tree
# $ eix-sync
#
# Search for libxml2
# $ eix libxml2
#############################################

enable_package "sphinx" do
  version "0.9.9"
end

# Install the newly unmasked version
package "app-misc/sphinx" do
  version "0.9.9"
  action :install
end
