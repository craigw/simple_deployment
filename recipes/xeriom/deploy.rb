namespace :deploy do
  task :setup, :roles => [ :app, :db, :web ] do
    add_application_user_account
    add_my_ssh_key_to_application_users_authorized_keys
    create_application_directories
  end

  task :add_application_user_account, :roles => [ :app, :db, :web ] do
    as_administrator do
      sudo "id #{fetch(:application_username)} > /dev/null 2>&1 || (sudo /usr/sbin/groupadd #{fetch(:application_username)}; /usr/sbin/useradd -g xit -m -c '#{fetch(:application_username)}' #{fetch(:application_username)}) > /dev/null"
    end
  end

  task :add_my_ssh_key_to_application_users_authorized_keys, :roles => [ :app, :db, :web ] do
    # SSH as an administrator and create the user required for this 
    # application.
    #
    as_administrator do
      key = ssh_options[:keys].detect{ |f| File.exists?("#{f}.pub") }
      if !key.nil?
        public_key = File.read("#{key}.pub")
        users_ssh_dir = "~#{application_username}/.ssh"
        authorized_keys_file = "#{users_ssh_dir}/authorized_keys"
        put public_key, "uploaded_identity.pub"
        as_administrator do
          sudo "mkdir -p #{users_ssh_dir}"
          sudo "touch #{authorized_keys_file}"
          sudo "mv ~/uploaded_identity.pub #{authorized_keys_file}"
          sudo "chown -R #{application_username}:#{application_username} #{users_ssh_dir}"
          sudo "chmod 0700 #{users_ssh_dir}"
          sudo "chmod 0600 #{authorized_keys_file}"
        end
      else
        abort <<-MESSAGE
        Couldn't find your SSH identity file.
        You should create one and try again.
        MESSAGE
      end
    end
  end

  task :create_application_directories, :roles => [ :app, :db, :web ] do
    as_administrator do
      # Build the directories required by the application and chown them
      # to the correct user for this app.
      #
      sudo "mkdir -p #{deploy_to}/releases"
      [ :system, :log, :pids, :config, :assets ].each do |dir|
        sudo "mkdir -p #{deploy_to}/shared/#{dir}"
      end
      sudo "chown -R #{application_username}:#{application_username} #{deploy_to}"
    end
  end

  task :initial, :roles => [ :app, :db, :web ] do
    top.deploy.update_code
    top.deploy.symlink
  end

  task :stop, :roles => [ :app ] do
    top.mongrel.stop
  end

  task :start, :roles => [ :app ] do
    top.mongrel.start
  end

  task :restart, :roles => [ :app ] do
    top.mongrel.restart
  end

  task :chown_application, :roles => [ :app, :db, :web ] do
    as_administrator do
      sudo "chown -R #{application_username}:#{application_username} #{deploy_to}"
    end
  end
end

after :"deploy:setup", :"deploy:chown_application"
after :"deploy:setup", :"gems:configure"
after :"deploy:setup", :"mongrel:configure"
after :"deploy:setup", :"mongrel:symlink"
after :"deploy:setup", :"mysql:start"
before :"deploy:initial", :"assets:directories:create"
after :"deploy:initial", :"mongrel:start"
after :"deploy:initial", :"mysql:configure"

# Make sure users won't hit the database when we're running migrations.
#
before :"deploy:migrations",  :"deploy:web:disable"
after  :"deploy:migrations",  :"deploy:web:enable"