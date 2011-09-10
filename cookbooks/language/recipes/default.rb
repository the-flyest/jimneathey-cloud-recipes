# settings
lang = "en_US.UTF-8"

# set default language
bash_profile = "/home/#{node[:owner_name]}/.bash_profile"

bash "set language" do
  user node[:owner_name]
  code <<-EOH
    echo "export LANG=#{lang}" >> #{bash_profile}
    source #{bash_profile}
  EOH
  not_if "grep LANG #{bash_profile}"
end