module Xeriom # :nodoc:
  module CoreExtensions # :nodoc:
    module Numeric # :nodoc:
      module AsWords
        def self.included(base) # :nodoc:
          base.send(:include, InstanceMethods)
        end

        module InstanceMethods
          NUMBERS_AS_WORDS = [ "zero", "one", "two", "three", "four", "five", "six", "seven", "eight", "nine" ]

          def as_words
            self.to_s.scan(/./).collect do |digit| 
              case digit
              when "."
                "point"
              when /[^0-9]/
                digit
              else
                NUMBERS_AS_WORDS[digit.to_i]
              end
            end.flatten.compact.join(" ")
          end
        end
      end
    end
  end
end