ENV["RAILS_ENV"] = "test"
require File.expand_path(File.dirname(__FILE__) + "/../../../../config/environment")
require 'spec/rails'

$:.unshift(File.expand_path(File.dirname(__FILE__)) + "/../lib")

Spec::Runner.configure do |config|
  config.use_transactional_fixtures = true
  config.use_instantiated_fixtures  = false
  config.mock_with :mocha
end