namespace :db do  
  desc <<-DESC
  Backup the database for the current environment by dumping it to
  db/<environment>-data.sql.gz.
  DESC
  task :backup => :environment do
    config = ActiveRecord::Base.configurations[RAILS_ENV]
    cmd = ['mysqldump']
    if !config['host'].blank?
      cmd << "--host='#{config['host']}'"
    end
    if config['username'].blank?
      cmd << "--user='root'"
    else
      cmd << "--user='#{config['username']}'"
    end
    if !config['password'].blank?
      cmd << "--password='#{config['password']}'"
    end
    cmd << config['database']
    cmd << " | gzip > #{RAILS_ROOT}/db/#{RAILS_ENV}-data.sql.gz"
    `#{cmd.flatten.join ' '}`
  end

  desc <<-DESC
  Create the database defined in config/database.yml for the current 
  Rails environment.
  DESC
  task :create => :environment do
    config = ActiveRecord::Base.configurations[RAILS_ENV]
    if [ nil, '', 'localhost', '127.0.0.1' ].include? config['host']
      command =<<-SH
      mysql -u root \
      --exec='create database if not exists `#{config['database']}`;
      grant all on `#{config['database']}`.*
      to `#{config['username']}`@`localhost` 
      identified by "#{config['password']}"'
      SH
      `#{command}`
    else
      puts <<-MESSAGE
      This task only creates local users.
      #{config['database']} is on a remote host.
      MESSAGE
    end
  end
end