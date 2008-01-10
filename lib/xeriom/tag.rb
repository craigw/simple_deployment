module Xeriom # :nodoc:
  # A standard Tag class for all our applications.
  #
  class Tag < ActiveRecord::Base
    # Despite beind namespaced we want to manage the Tags table.
    #
    set_table_name "tags"
  end
end