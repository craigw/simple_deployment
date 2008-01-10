module Xeriom # :nodoc:
  module CoreExtensions # :nodoc:
    module String # :nodoc:
      # Levenshtein distance algorithm implementation for Ruby, with UTF-8 support.
      #
      # The Levenshtein distance is a measure of how similar two strings s and t are,
      # calculated as the number of deletions/insertions/substitutions needed to
      # transform s into t. The greater the distance, the more the strings differ.
      #
      # The Levenshtein distance is also sometimes referred to as the
      # easier-to-pronounce-and-spell 'edit distance'.
      #
      # Author: Paul Battley (pbattley@gmail.com)
      #
      # Extracted from the Music Tool project 2007-11-30.
      #
      module LevenshteinDistance
        def self.included(base) # :nodoc:
          base.send(:include, InstanceMethods)
        end

        module InstanceMethods
          # Calculate the Levenshtein distance between this string and +other+.
          #
          # This string and +other+ should be ASCII, UTF-8, or a one-byte-per 
          # character encoding such as ISO-8859-*.
          #
          # The strings will be treated as UTF-8 if $KCODE is set 
          # appropriately (i.e. 'u'). Otherwise, the comparison will be 
          # performed byte-by-byte. There is no specific support for Shift-JIS
          # or EUC strings.
          #
          # When using Unicode text, be aware that this algorithm does not 
          # perform normalisation. If there is a possibility of different 
          # normalised forms being used, normalisation should be performed 
          # beforehand.
          #
          def levenshtein_distance(other)
            unpack_rule = $KCODE =~ /^U/i ? 'U*' : 'C*'
            s = self.unpack(unpack_rule)
            t = other.unpack(unpack_rule)
            n = s.length
            m = t.length
            return m if s.blank?
            return n if t.blank?

            d = (0..m).to_a
            x = nil

            (0...n).each do |i|
              e = i+1
              (0...m).each do |j|
                cost = (s[i] == t[j]) ? 0 : 1
                x = [ d[j+1] + 1, # insertion
                e + 1,      # deletion
                d[j] + cost # substitution
                ].min
                d[j] = e
                e = x
              end
              d[m] = x
            end

            return x
          end
          alias_method :edit_distance, :levenshtein_distance
        end
      end
    end
  end
end