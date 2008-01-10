desc <<-DESC
  Backup the selected stage. Currently backs up shared assets and the 
  database.
DESC
task :backup do
  assets.backup
  mysql.backup
end