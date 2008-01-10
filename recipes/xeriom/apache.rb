# Where should we write the VHost configuration for this application?
#
set(:vhost_conf_path) { "#{shared_path}/config/vhost.conf" }

# Set this to true to have Apache handle requests for static assets.
# We should really be doing this - hitting the dispatcher for a static asset
# is really expensive and ties up our application. Let Apache do what it's 
# good at!
#
set :apache_serves_static_assets, true

# Who gets their email address splashed across Apache's error pages?
#
set(:server_administrator_email_address) { "admin@#{fetch(:fully_qualified_domain_name)}" }

# Which script should be used to control Apache?
#
set :apache_control_script, "/etc/init.d/apache2"

set :apache_stop_command, "stop"
set :apache_start_command, "start"
set :apache_restart_command, "force-reload"

# Which options should be passed to the Apache control script?
# These options are used for every invocation.
#
set :apache_control_options, ""

set(:apache_enable_site_command) { "a2ensite #{fetch(:fully_qualified_domain_name)}" }

set :apache_sites_vhost_conf_directory, "/etc/apache2/sites-available"
set(:apache_sites_vhost_conf_path) { "#{fetch(:apache_sites_vhost_conf_directory)}/#{fetch(:fully_qualified_domain_name)}" }

namespace :apache do
  desc <<-DESC
  Generates the application vhost definition and writes it into the 
  configuration directory.
  DESC
  task :configure, :roles => [ :web ] do
    # Calculate a recogniseable, unique proxy balancer name for access to the 
    # dispatcher cluster.
    balancer_name = "#{application}_#{stage}_cluster"
    public_path = current_path + '/public'
    vhost_template = File.dirname(__FILE__) + '/../resources/vhost.conf.erb'
    vhost_conf = ERB.new(File.read(vhost_template)).result(binding)
    logger.info "Uploading Virtual Host definition"
    put vhost_conf, vhost_conf_path, :mode => 0644
  end

  desc "Stop Apache"
  task :stop, :roles => [ :web ] do
    as_administrator { sudo "#{fetch(:apache_control_script)} #{fetch(:apache_stop_command)} #{fetch(:apache_control_options)}" }
  end

  desc "Start Apache"
  task :start, :roles => [ :web ] do
    as_administrator { sudo "#{fetch(:apache_control_script)} #{fetch(:apache_start_command)} #{fetch(:apache_control_options)}" }
  end

  desc "Restart Apache"
  task :restart, :roles => [ :web ] do
    as_administrator { sudo "#{fetch(:apache_control_script)} #{fetch(:apache_restart_command)} #{fetch(:apache_control_options)}" }
  end

  task :symlink, :roles => [ :web ] do
    desc <<-DESC
    Link this application's VHost definition into the system Apache
    configuration.
    DESC
    as_administrator do
      sudo <<-SH
        ln -nfs #{vhost_conf_path} #{apache_sites_vhost_conf_path}
      SH
    end
  end
  
  desc "Enable the site"
  task :enable_site, :roles => [ :web ] do
    run <<-SH
      #{fetch(:apache_enable_site_command)}
    SH
  end
end

# Configure Apache as part of the initial deploy.
#
before :"deploy:initial", :"apache:configure"

# TODO: Someone still needs to run apache:symlink manually
after :"apache:symlink", :"apache:enable_site"
after :"apache:enable_site", :"apache:restart"

# We require Apache 2.2 for this setup.
#
depend :remote, :match, "httpd -V", "Apache/2.2"

# Make sure the Apache setup is syntactically valid.
#
depend :remote, :match, "httpd -t", "Syntax OK"
