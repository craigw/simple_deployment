module Xeriom # :nodoc:
  module CoreExtensions # :nodoc:
    module Time # :nodoc:
      # Provide methods suitable for using Time as a Subversion tag.
      module SubversionTag
        def self.included(base) # :nodoc:
          base.send(:extend, SingletonMethods)
        end
        
        module SingletonMethods
          # Get a representation of the curent time suitable for use as part 
          # of a Subversion tag.
          #
          def as_subversion_tag
            now.gmtime.strftime '%Y_%m_%d_%H%M'
          end
        end
      end
    end
  end
end