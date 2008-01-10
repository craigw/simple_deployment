require File.expand_path(File.dirname(__FILE__)) + '/../../../spec_helper'

String.send(:include, Xeriom::CoreExtensions::String::LevenshteinDistance)

describe String do
  before(:each) do
    @string = "Test String"
  end
  
  it "should respond to levenshtein_distance" do
    @string.should respond_to(:levenshtein_distance)
  end

  it "should respond to edit_distance" do
    @string.should respond_to(:edit_distance)
  end
  
  it "should return the correct levenshtein distance between self and another string" do
    @string.levenshtein_distance("Test Strong").should eql(1)
  end

  it "should return the correct edit distance between self and another string" do
    @string.edit_distance("Test Strong").should eql(1)
  end

  it "should the same value for edit_distance and levenschtein_distance" do
    test_string = "Testing Willpower"
    @string.levenshtein_distance(test_string).should eql(@string.edit_distance(test_string))
  end

  after(:each) do
    @string = nil
  end
end