module Xeriom # :nodoc:
  module CoreExtensions # :nodoc:
    module Time # :nodoc:
    end
  end
end

require File.dirname(__FILE__) + '/time/subversion_tag'
require File.dirname(__FILE__) + '/time/backup_timestamp'
require File.dirname(__FILE__) + '/time/asset_timestamp'

Time.send(:include, Xeriom::CoreExtensions::Time::SubversionTag)
Time.send(:include, Xeriom::CoreExtensions::Time::BackupTimestamp)
Time.send(:include, Xeriom::CoreExtensions::Time::AssetTimestamp)