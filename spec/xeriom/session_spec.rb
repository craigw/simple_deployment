require File.expand_path(File.dirname(__FILE__)) + '/../spec_helper'

describe Xeriom::Session do
  it "should respond to expire_old_sessions" do
    Xeriom::Session.should respond_to(:expire_old_sessions)
  end
  
  it "should clear out old sessions when expire_old_sessions is called" do
    # File and line used here to give us a pretty high change of it being a
    # unique session id.
    #
    expired_session_id = "Expired Session (#{__FILE__} #{__LINE__})"
    expired = Time.now - (Xeriom::Session.timeout + 1.second)
    session = Xeriom::Session.create :session_id => expired_session_id
    session.connection.execute("update #{Xeriom::Session.table_name} set updated_at = '#{expired}' where session_id = '#{expired_session_id}'")
    lambda {
      Xeriom::Session.expire_old_sessions
    }.should change(Xeriom::Session, :count).from(Xeriom::Session.count).to(Xeriom::Session.count - 1)
  end
end

describe "A session" do
  before(:each) do
    @session = Xeriom::Session.new
  end

  it "should respond to expired?" do
    @session.should respond_to(:expired?)
  end
  
  it "should not be expired when new" do
    @session.should_not be(:expired)    
  end
  
  it "should know if it has expired" do
    @session.stubs(:updated_at).returns(Time.now - ((Xeriom::Session.timeout + 1.second)))
    @session.should be(:expired)
  end

  it "should know if it is not expired" do
    @session.stubs(:updated_at).returns(Time.now + 1.second)
    @session.should_not be(:expired)
  end

  after(:each) do
    @session = nil
  end
end