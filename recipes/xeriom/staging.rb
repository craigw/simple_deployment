USER_STAGES_PATH = File.expand_path(File.dirname(__FILE__) + '../../../../../../config/stages')
DEFAULT_STAGES_PATH = File.expand_path(File.dirname(__FILE__) + '/stages')

STAGES = if !defined?(STAGES)
  all_stage_definitions = (Dir[DEFAULT_STAGES_PATH + '/*.rb'] + Dir[USER_STAGES_PATH + '/*.rb'])
  all_stage_definitions.collect{ |stage| File.basename(stage, '.rb') }.flatten.compact.uniq
end

set :default_stage, STAGES.include?("staging") ? "staging" : nil
set :domain, "xeriom.net"
set :enable_staging, true
set(:deploy_to) { "/var/www/#{application}-#{stage}" }
set(:rails_environment) { stage == "integration" ? "development" : stage }
set(:fully_qualified_domain_name) { "#{dns_name}#{stage != "production" ? "-#{stage}" : ""}.#{domain}" }

load_paths << USER_STAGES_PATH
load_paths << DEFAULT_STAGES_PATH

namespace :deploy do
  task :ensure_a_stage_is_selected do
    if fetch(:enable_staging)
      if !STAGES.include?("production")
        logger.important <<-MESSAGE
        You have not defined a production environment.
        This is not a fatal error but you should define it in 
        config/stages/production.rb as soon as possible.
        MESSAGE
      end
      if !exists?(:stage)
        if exists?(:target) && STAGES.include?(target)
          find_and_execute_task(target)
        elsif exists?(:default_stage) && STAGES.include?(fetch(:default_stage))
          logger.important "Defaulting to `#{default_stage}' environment"
          find_and_execute_task(default_stage)
        else
          abort <<-MESSAGE
          No stage specified. Please specify one of: 
          #{stages.join(', ')} (e.g. `cap #{stages.first} #{ARGV.last}')
          MESSAGE
        end
      end
    else
      if !STAGES.include?("production")
        abort "Staging has been disabled and you have not defined a production target so I can't continue"
      else
        logger.important "Staging disabled - assuming target is production"
        find_and_execute_task("production")
      end
    end
  end
  on :start, "deploy:ensure_a_stage_is_selected", :except => STAGES
end

STAGES.each do |stage|
  desc <<-DESC
  Apply the following commands to the #{stage} environment.
  DESC
  task stage do
    logger.important "Working with the `#{stage}' environment"
    load stage
    set :stage, stage
  end
end