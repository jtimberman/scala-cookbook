#--------------------------------------------------------------------------------
# Required recipes
#--------------------------------------------------------------------------------

require_recipe "apt"

#-------------------------------------------------------------------------------
# Packages
#-------------------------------------------------------------------------------

package "openjdk-6-jre"

#-------------------------------------------------------------------------------
# Remote files
#-------------------------------------------------------------------------------

remote_file "/tmp/scala-#{node[:scala_version]}.tgz" do
  source "#{node[:scala_base_url]}scala-#{node[:scala_version]}.tgz"
  not_if do `ls /usr/bin`.include?("scala") end
end

#-------------------------------------------------------------------------------
# Installation Actions
#-------------------------------------------------------------------------------

bash "unpack-scala" do
  cwd "/tmp"
  code "tar zxvf scala-#{node[:scala_version]}.tgz"
  not_if do `ls /usr/bin`.include?("scala") end
end

bash "move-scala" do
  cwd "/tmp"
  code "mv scala-#{node[:scala_version]} /usr/share/scala"
  not_if do `ls /usr/bin`.include?("scala") end
end

["scala", "scalac"].each do |bin_file|

  link "/usr/bin/#{bin_file}" do
    to "/usr/share/scala/bin/#{bin_file}"
    not_if do `ls /usr/bin`.include?(bin_file) end
  end

end

#-------------------------------------------------------------------------------
# Cleanup
#-------------------------------------------------------------------------------

file "/tmp/scala-#{node[:scala_version]}.tgz" do
  action :delete
end
