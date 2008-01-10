module Xeriom # :nodoc:
  module CoreExtensions # :nodoc:
    module String # :nodoc:
      module ToTags
        def self.included(base) # :nodoc:
          base.send(:include, InstanceMethods)
        end

        module InstanceMethods
          # This function splits the given string up into indiviual terms
          # and puts them into an array. You can use "quotes" to put in things
          # like "Duncan Ponting"
          #
          # Extracted from Photo Tool 2007-11-30.
          #
          def to_tags
            quoted_tags = self.scan(/"([^"]+)"/)
            unquoted_tags = self.gsub(/"[^"]+"/,'').split
            (quoted_tags | unquoted_tags).flatten.compact.uniq.delete_if(&:empty?).collect(&:to_tag)
          end
          
          def to_tag
            Tag.new(self)
          end
        end
      end
    end
  end
end