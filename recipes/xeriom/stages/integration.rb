# These are the default settings for a integration environment.
# You can overwrite the hosts used in your own config/stages/integration.rb
#
# The integration environment is used to test systems integration. It should
# be a clone of production except linked up to test datasources so destructive
# actions won't affect live data.
#
role :web, "#{dns_name}-integration.#{domain}"
role :app, "#{dns_name}-integration.#{domain}"
role :db, "#{dns_name}-integration.#{domain}", :primary => true