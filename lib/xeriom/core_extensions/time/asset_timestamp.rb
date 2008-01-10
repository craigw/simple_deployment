module Xeriom # :nodoc:
  module CoreExtensions # :nodoc:
    module Time # :nodoc:
      # Provide methods that will allow a Time to be used as an asset 
      # timestamp eg for thwarting evil web caches.
      #
      module AssetTimestamp
        def self.included(base) # :nodoc:
          base.send(:extend, ClassMethods)
        end

        module ClassMethods
          # Get a representation of the current time as a string suitable for
          # an asset timestamp.
          #
          def as_asset_timestamp
            now.to_i
          end
        end
      end
    end
  end
end