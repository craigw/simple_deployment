# These are the default settings for a production environment.
# You can overwrite the hosts used in your own config/stages/production.rb
#
# The production environment is where the app is accessible to the end users.
#
role :web, "#{dns_name}.#{domain}"
role :app, "#{dns_name}.#{domain}"
role :db, "#{dns_name}.#{domain}", :primary => true