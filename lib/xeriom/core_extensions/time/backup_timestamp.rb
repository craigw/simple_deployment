module Xeriom # :nodoc:
  module CoreExtensions # :nodoc:
    module Time # :nodoc:
      # Provide methods that will allow a Time to be used as a backup 
      # timestamp eg for a backup filename.
      #
      module BackupTimestamp
        def self.included(base) # :nodoc:
          base.send(:extend, SingletonMethods)
        end

        module SingletonMethods
          # Get a representation of the current time as a string suitable for
          # a backup filename.
          #
          def as_backup_timestamp
            now.gmtime.strftime '%Y%m%d%H%M%S'
          end
        end
      end
    end
  end
end