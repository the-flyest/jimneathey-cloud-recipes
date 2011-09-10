# settings
lang = "en_US.UTF-8"

# set default language
bash "set language" do
  user 'root'
  code <<-EOH
    echo "export LANG=#{lang}" >> /etc/profile
    source /etc/profile
  EOH
  not_if "grep LANG /etc/profile"
end