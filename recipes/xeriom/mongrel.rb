set :dispatcher_instances, 3
set :first_dispatcher_port, 8000
set(:mongrel_config) { "#{shared_path}/config/mongrel_cluster.yml" }
set :mongrel_rails_command, "/var/lib/gems/1.8/bin/mongrel_rails"

namespace :mongrel do
  desc "Configure Mongrel."
  task :configure, :roles => [ :app ] do
    as_administrator do
      sudo <<-SH
      #{fetch(:mongrel_rails_command)} cluster::configure \
      -e #{fetch(:rails_environment)} \ 
      -p #{first_dispatcher_port} -a 127.0.0.1 \
      -c #{current_path} -N #{dispatcher_instances} \
      -C #{fetch(:mongrel_config)} \
      -l #{shared_path}/log/mongrel.log \
      -P #{shared_path}/pids/mongrel.pid \
      --user #{fetch(:application_username)} \
      --group #{fetch(:application_username)}
      SH
      sudo "chown #{fetch(:application_username)}:#{fetch(:application_username)} #{fetch(:mongrel_config)}"
      sudo "mkdir -p /etc/mongrel_cluster/"
      sudo "cp /var/lib/gems/1.8/gems/mongrel_cluster-*/resources/mongrel_cluster /etc/init.d"
      sudo "chmod +x /etc/init.d/mongrel_cluster"
      sudo "update-rc.d mongrel_cluster defaults"
    end
  end

  desc <<-DESC
  Link this application's Mongrel cluster into the system mongrel
  configuration.
  DESC
  task :symlink, :roles => [ :app ] do
    as_administrator do
      sudo "ln -nfs #{fetch(:mongrel_config)} /etc/mongrel_cluster/#{application}-#{stage}.yml"
    end
  end

  task :start, :roles => [ :app ] do
    run "cd #{current_path} && mongrel_rails cluster::start -C #{fetch(:mongrel_config)}"
  end

  task :stop, :roles => [ :app ] do
    run "cd #{current_path} && mongrel_rails cluster::stop -C #{fetch(:mongrel_config)}"
  end

  task :restart, :roles => [ :app ] do
    stop
    start
  end
end