module Xeriom # :nodoc:
  # A session management class for using ActiveRecordStore.
  #
  class Session < ActiveRecord::Base
    # Despite being namespaced, we're not managing the xeriom_sessions table -
    # we want to manage the sessions table.
    #
    set_table_name "sessions"
    
    # Yes, I know they're broken. No, I don't care. Either don't subclass or
    # fix this to work.
    #
    @@timeout = 30.minutes
    cattr_accessor :timeout

    class << self
      # Expire all sessions that haven't been updated in the last 30 minutes.
      #
      # The ideal way of running this is by using script/runner from Cron - 
      # something like this:
      #
      #   */5 * * * * #{current_path}/script/runner -e #{environment} \
      #       -c 'Xeriom::Session.expire_old_sessions'
      #
      def expire_old_sessions
        delete_all [ "updated_at < ?", timeout.seconds.ago ]
      end
    end

    # Has this session expired?
    #
    def expired?
      (updated_at || Time.now) < Session.timeout.seconds.ago
    end
  end
end