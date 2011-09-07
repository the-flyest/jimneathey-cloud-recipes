# settings
version = "0.16.7"

# uninstall
package "app-text/poppler" do
  action :remove
end

# install prerequisites
package "media-libs/openjpeg" do
  action :install
end

# download source
remote_file "/tmp/poppler-#{version}.tar.gz" do
  source "http://poppler.freedesktop.org/poppler-#{version}.tar.gz"
  owner "root"
  group "root"
end

# install
bash "install poppler from source" do
  user "root"
  cwd "/tmp"
  code <<-EOF
    tar -zxvf poppler-#{version}.tar.gz
    cd poppler-#{version}/ 
    ./configure --prefix /usr
    make
    make install
  EOF
end