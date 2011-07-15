# install link-parser
version = '4.7.4'

bash "install link-parser" do
  user "root"
  cwd "/tmp"
  code <<-EOH
    wget http://www.abisource.com/downloads/link-grammar/#{version}/link-grammar-#{version}.tar.gz
    tar -zvxf link-grammar-#{version}.tar.gz 
    cd link-grammar-#{version}
    ./configure
    make
    make install
  EOH
end