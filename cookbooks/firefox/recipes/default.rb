# install dependencies
package "dev-libs/dbus-glib" do
  version "0.76"
  action :install
end

package "x11-libs/libXrender" do
  version "0.9.2"
  action :install
end

package "x11-libs/libXt" do
  version "1.0.5"
  action :install
end

package "x11-libs/libXmu" do
  version "1.0.3"
  action :install
end

package "x11-libs/gtk+" do
  version "2.12.11"
  action :install
end

package "media-libs/alsa-lib" do
  version "1.0.16"
  action :install
end

# install firefox binary
bash "install_firefox" do
  user "root"
  cwd "/tmp"
  code <<-EOF
    wget http://download.mozilla.org/?product=firefox-3.6.17&os=linux&lang=en-US
    tar -zxf firefox-3.6.17.tar.bz2
    mv /tmp/firefox /usr/bin/firefox
  EOF
  not_if "test -d /usr/bin/firefox"
end