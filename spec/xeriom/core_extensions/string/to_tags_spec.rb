require File.expand_path(File.dirname(__FILE__)) + '/../../../spec_helper'

String.send(:include, Xeriom::CoreExtensions::String::EscapeForShell)

describe String do
  it "should respond to to_tags"
end