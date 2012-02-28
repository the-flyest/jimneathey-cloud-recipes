%w[gui script core sql qt3support webkit].each do |part|
  enable_package "x11-libs/qt-#{part}" do 
    version node[:qt_version] 
  end
end

package 'x11-libs/qt-webkit' do 
  version node[:qt_version] 
  action :install 
end

bash "compile phantomjs" do
  user 'root'
  cwd "/tmp"
  code <<-EOH
    git clone git://github.com/ariya/phantomjs.git
    cd phantomjs
    git checkout #{node[:phantomjs_version]}
    qmake
    make
  EOH
end