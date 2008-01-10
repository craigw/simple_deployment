module Xeriom # :nodoc:
  module CoreExtensions # :nodoc:
    module String # :nodoc:
    end
  end
end

require File.dirname(__FILE__) + '/string/escape_for_shell'
require File.dirname(__FILE__) + '/string/levenshtein_distance'
require File.dirname(__FILE__) + '/string/regular_expression_comparison'

String.send(:include, Xeriom::CoreExtensions::String::EscapeForShell)
String.send(:include, Xeriom::CoreExtensions::String::LevenshteinDistance)
String.send(:include, Xeriom::CoreExtensions::String::RegularExpressionComparison)