require 'xeriom/platform/not_production_warning'

module Xeriom # :nodoc:
  # Provide information about the application platform.
  #
  module Platform
    # Which environments are considered "production"?
    #
    # Most of the time this should be left unchanged. We may wish to have a
    # new environment considered "production" though - a beta environment for 
    # example - in which case do something like this at the bottom of 
    # <code>config/environment.rb</code>:
    #
    #    Xeriom::Platform.production_environments += "beta"
    #
    @@production_environments = %W(production)
    mattr_accessor :production_environments

    # Is the application running in a production environment?
    #
    def self.production_environment?
      @@production_environments.include? RAILS_ENV
    end
  end
end

ActionController::Base.send(:include, Xeriom::Platform)
ActionController::Base.send(:include, Xeriom::Platform::NotProductionWarning)