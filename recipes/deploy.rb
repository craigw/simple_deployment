# This file is autoamtically loaded by the default Capfile. That's handy :)

require File.dirname(__FILE__) + '/../lib/xeriom/core_extensions/time.rb'
require File.dirname(__FILE__) + '/../lib/xeriom/core_extensions/string.rb'

load_paths << File.dirname(__FILE__)

def as_administrator(&block)
  as_user fetch(:administrative_user, ENV['USER']), &block
end

def as_user(username, &block)
  old_user = fetch(:user)
  set :user, username
  logger.info "Working as #{fetch(:user)}..."
  yield
  set :user, old_user
  logger.info "Working as #{fetch(:user)}..."
end

# Load all the ingredients required for our recipe.
#
[ 
  :assets, :apache, :backup, :cron, :deploy, :gems, :mysql, :mongrel, 
  :staging, :subversion 
].each do |ingredient|
load "xeriom/#{ingredient}"
end

# Default options.
set(:user) { fetch(:application) }
set(:dns_name) { fetch(:application).downcase.gsub(/[^a-z0-9]/, '-') }

# SSH options for using our identity file and to make ssh less scared
# of everything.
#
ssh_options[:keys] = [ "#{ENV['HOME']}/.ssh/identity", "#{ENV['HOME']}/.ssh/id_rsa" ]
ssh_options[:paranoid] = false
ssh_options[:forward_agent] = true

# Use the old-style connections so we can be prompted for passwords.
#
default_run_options[:pty] = true

set :keep_releases, 3 # Only keep three past releases.
set :use_sudo, false

task :capture_application_username do
  set :application_username, fetch(:user)
end

on :start, :capture_application_username