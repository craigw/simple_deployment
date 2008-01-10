module Xeriom # :nodoc:
  module Platform # :nodoc:
    module NotProductionWarning
      # Which tags should the warning be placed after?
      #
      # This is a regular expression.
      #
      @@add_after_tag = /<body>/

      # Should the banner be displayed if we're not running in a production
      # environment?
      #
      @@display_banner = false

      # What warning message should be used?
      #
      @@warning_message = %Q(<div class="environment warning banner" id="environment_warning_banner">Warning: This not the production instance.</div>)
      mattr_accessor :add_after_tag, :display_banner, :warning_message

      def self.included(base) # :nodoc:
        base.send(:include, Filters)
        base.class_eval do
          after_filter :add_not_production_warning_if_enabled
        end
      end

      module Filters # :nodoc:
        private
        def add_not_production_warning_if_enabled
          if response.body.respond_to?(:gsub!) && Xeriom::Platform::NotProductionWarning.display_banner && !Xeriom::Platform.production_environment?
            response.body.gsub!(Xeriom::Platform::NotProductionWarning.add_after_tag, Xeriom::Platform::NotProductionWarning.warning_message % [ RAILS_ENV ])
          end
        end
      end
    end
  end
end