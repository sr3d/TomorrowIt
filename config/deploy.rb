require 'erb'
require 'yaml'
require 'fileutils'

set :application, "tomorrowit"
set :repository,  "http://sr3d.unfuddle.com/svn/sr3d_tomorrowit/tomorrowit"
set :port, 22000

set :user, "rails"
set :group, "rails"


desc "Staging server setup"
task :staging do
  role :web, "dev.tubecaption.com"
  role :app, "dev.tubecaption.com"
  role :db,  "dev.tubecaption.com", :primary => true
  set :deploy_to, "/var/www/sites/dev.tubecaption.com/#{application}"
  set :app_database, "dev_#{application}"
end

desc "Set live application variables"
task :live do
  role :app, "www.tomorrowit.com"
  role :web, "www.tomorrowit.com"
  role :db,  "db01.tomorrowit.com", :primary => true
  set :deploy_to, "/var/www/sites/www.tomorrowit.com/#{application}"
  #set :mongrel_conf, "#{current_path}/config/mongrel_cluster.yml"
  set :app_database, "#{application}"
end


desc "Link in the production database.yml"
task :after_update_code, :roles => [:web] do
  database_configuration_template = <<-CMD
login: &login
  adapter: mysql
  host: tcdb01
  port: 33060

development:
  database: <%= "#{app_database}_development" %>
  <<: *login
  username: devuser
  password: d3v3l0p3r


test:
  database: <%= "#{app_database}_test" %>
  <<: *login

production:
  database: <%= "#{app_database}_production" %>
  <<: *login
  username: produser
  password: p0w3ruser

CMD

  database_configuration = ERB.new( database_configuration_template ).result(binding)
  run "mkdir -p #{shared_path}/config"
  put database_configuration, "#{shared_path}/config/database.yml"  
  
  run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
  
  # Make sure the config files are good.  Logrotate barks about dos linebreaks
  run "dos2unix #{release_path}/config/*.*"
  # change the permission of the shell scripts
  run "dos2unix #{release_path}/script/*.sh;chmod +x #{release_path}/script/*.sh"
  
end


task :underconstruction do
  underconstruction = <<-CMD
<h3>Under construction</h3>
CMD
  put underconstruction, "#{current_path}/public/index.html"  
end