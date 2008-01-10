# These are the default settings for a integration environment.
# You can overwrite the hosts used in your own config/stages/integration.rb
#
# The integration environment is used by the continuous integration builder.
#
role :web, "#{dns_name}-integration.#{domain}"
role :app, "#{dns_name}-integration.#{domain}"
role :db, "#{dns_name}-integration.#{domain}", :primary => true