module Xeriom # :nodoc:
  module CoreExtensions # :nodoc:
    module Symbol # :nodoc:
      module Comparable
        def self.included(base) # :nodoc:
          base.send(:include, InstanceMethods)
        end
        
        module InstanceMethods
          def <=>(other)
            self.to_s <=> other.to_s
          end
        end
      end
    end
  end
end