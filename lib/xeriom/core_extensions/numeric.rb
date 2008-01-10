module Xeriom # :nodoc:
  module CoreExtensions # :nodoc:
    module Numeric # :nodoc:
    end
  end
end

require File.dirname(__FILE__) + '/numeric/as_words'

Numeric.send(:include, Xeriom::CoreExtensions::Numeric::AsWords)