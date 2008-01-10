require File.expand_path(File.dirname(__FILE__)) + '/../../../spec_helper'

Time.send(:include, Xeriom::CoreExtensions::Time::BackupTimestamp)

describe Time do
  it "should respond to as_backup_timestamp" do
    Time.should respond_to(:as_backup_timestamp)
  end

  it "should be returned as a string in the format YYYYMMDDHHMMSS as a subversion tag" do
    Time.stubs(:now).returns(Time.new)
    Time.as_backup_timestamp.should eql(Time.now.strftime('%Y%m%d%H%M%S'))
  end
end