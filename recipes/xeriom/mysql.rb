set :mysql_init_script, "/etc/init.d/mysql"

namespace :mysql do
  desc "Setup the database"
  task :configure, :roles => [ :db ] do
    run "cd #{current_path} && rake RAILS_ENV=#{rails_environment} db:create"
    run "cd #{current_path} && rake RAILS_ENV=#{rails_environment} db:schema:load"
    run "cd #{current_path} && rake RAILS_ENV=#{rails_environment} db:migrate"
  end

  task :start, :roles => [ :db ] do
    as_administrator { sudo "#{fetch(:mysql_init_script)} start" }
  end

  task :stop, :roles => [ :db ] do
    as_administrator { sudo "#{fetch(:mysql_init_script)} stop" }
  end

  task :restart, :roles => [ :db ] do
    as_administrator { sudo "#{fetch(:mysql_init_script)}  restart" }    
  end

  task :backup, :roles => [ :db ] do
    run "cd #{current_path} && rake RAILS_ENV=#{rails_environment} db:backup"
    get "#{current_path}/db/#{stage}-data.sql.gz", File.dirname(__FILE__) + "/../../../../../db/#{stage}-#{Time.as_backup_timestamp}.sql.gz"
  end
end