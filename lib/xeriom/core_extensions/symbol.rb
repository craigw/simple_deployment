module Xeriom # :nodoc:
  module CoreExtensions # :nodoc:
    module Symbol # :nodoc:
    end
  end
end

require File.dirname(__FILE__) + '/symbol/comparable'
Symbol.send(:include, Xeriom::CoreExtensions::Symbol::Comparable)