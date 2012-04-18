# settings
alert_email = "your@email.com"
smtp_email = "your@email.com"
smtp_password = "password"

# update monitrc
execute "update monitrc" do 
  command %Q{ 
    echo "set mailserver smtp.gmail.com port 587 username '#{smtp_email}' password '#{smtp_password}' using tlsv1 with timeout 30 seconds\nset alert #{alert_email}" >> /etc/monitrc
  }
  not_if "grep #{alert_email} /etc/monitrc"
end

# reload monit
execute "monit reload"