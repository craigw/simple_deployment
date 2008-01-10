namespace :db do
  namespace :fixtures do
    desc "Create YAML test fixtures from data in an existing database."
    task :dump => :environment do 
      sql = "SELECT * FROM %s"
      skip_tables = [ "schema_info" ]

      ActiveRecord::Base.establish_connection 
      (ActiveRecord::Base.connection.tables - skip_tables).each do |table_name| 
        i = "000000" 
        fixtures = File.open("#{RAILS_ROOT}/test/fixtures/#{table_name}.yml", 'w')
        data = ActiveRecord::Base.connection.select_all(sql % table_name) 
        yaml = data.inject({}) do |hash, record| 
          hash["#{table_name}_#{i.succ!}"] = record 
          hash 
        end.to_yaml
        fixtures.write(yaml)
        fixtures.close
      end
    end
  end
end