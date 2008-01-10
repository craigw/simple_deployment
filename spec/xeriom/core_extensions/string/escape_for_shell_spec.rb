require File.expand_path(File.dirname(__FILE__)) + '/../../../spec_helper'

String.send(:include, Xeriom::CoreExtensions::String::EscapeForShell)

describe String do
  it "should respond to escape_for_shell" do
    String.new.should respond_to(:escape_for_shell)
  end
end

describe String, "being shell escaped" do
  before(:each) do
    @string = '|&\'"\\'
  end
  
  it "should shell escape |" do
    @string.escape_for_shell.should match(%r{\|})
  end

  it "should shell escape &" do
    @string.escape_for_shell.should match(%r{\&})
  end

  it "should shell escape '" do
    @string.escape_for_shell.should match(%r{\'})
  end

  it "should shell escape \"" do
    @string.escape_for_shell.should match(%r{\"})
  end

  it "should shell escape \\" do
    @string.escape_for_shell.should match(%r{\\})
  end

  after(:each) do
    @string = nil
  end
end