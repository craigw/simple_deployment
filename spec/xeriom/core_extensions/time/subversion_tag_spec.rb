require File.expand_path(File.dirname(__FILE__)) + '/../../../spec_helper'

Time.send(:include, Xeriom::CoreExtensions::Time::SubversionTag)

describe Time do
  it "should respond to as_subversion_tag" do
    Time.should respond_to(:as_subversion_tag)
  end

  it "should be returned as a string in the format YYYY_MM_DD_HHMM as a subversion tag" do
    Time.stubs(:now).returns(Time.new)
    Time.as_subversion_tag.should eql(Time.now.strftime('%Y_%m_%d_%H%M'))
  end
end