# These are the default settings for a staging environment.
# You can overwrite the hosts used in your own config/stages/staging.rb
#
# Staging is used by QA to perform acceptance testing.
#
role :web, "#{dns_name}-staging.#{domain}"
role :app, "#{dns_name}-staging.#{domain}"
role :db, "#{dns_name}-staging.#{domain}", :primary => true