module Xeriom # :nodoc:
  module CoreExtensions # :nodoc:
    module String # :nodoc:
      # Allow us to do stuff like...
      # 
      # case request.env['HTTP_USER_AGENT']
      # when /msie/i
      #   # ...
      # else
      #   # ...
      # end
      #
      module RegularExpressionComparison
        def self.included(base)
          base.send(:include, InstanceMethods)

          # Can't use alias_method_chain here because it tries to be
          # smart with trailing punctuation.
          base.send :alias_method, "===_without_regexp_case_equality", "==="
          base.send :alias_method, "===", "===_with_regexp_case_equality"
        end

        module InstanceMethods
          define_method :"===_with_regexp_case_equality" do |other|
            case other # What are we being compared to?
            when Regexp # We're being compared to a regular expression.
              # Check for a match.
              !send(:=~, other).nil?
            else # Regular comparison
              # Use the regular === operation.
              send :"===_without_regexp_case_equality", other
            end
          end
        end
      end
    end
  end
end