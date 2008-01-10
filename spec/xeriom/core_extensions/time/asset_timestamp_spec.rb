require File.expand_path(File.dirname(__FILE__)) + '/../../../spec_helper'

Time.send(:include, Xeriom::CoreExtensions::Time::AssetTimestamp)

describe Time do
  it "should respond to as_asset_timestamp" do
    Time.should respond_to(:as_asset_timestamp)
  end

  it "should be returned as the number of seconds since the epoch for use as an asset timestamp" do
    Time.stubs(:now).returns(Time.new)
    Time.as_asset_timestamp.should eql(Time.now.to_i)
  end
end