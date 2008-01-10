module Xeriom # :nodoc:
  module CoreExtensions # :nodoc:
    module String # :nodoc:
      # Provide methods to make a string safe to use as an argument to a 
      # shell command.
      #
      # Extracted from Programme Information Tool c2007-11-25.
      #
      module EscapeForShell
        def self.included(base) # :nodoc:
          base.send(:include, InstanceMethods)
        end

        module InstanceMethods
          # Make this string safe for running in a shell by escaping all 
          # characters that may be interperited by the shell. This is useful 
          # for building commands that will be run in a subshell.
          #
          def escape_for_shell(times = 1)
            escaped_string = self.gsub('\\','\0\0').gsub(/["'\*#&|]/) { |m| "\\#{m}" }
            times > 1 ? escaped_string.escape_for_shell(times - 1) : escaped_string
          end
        end
      end
    end
  end
end