set :asset_directories, []

namespace :assets do
  namespace :directories do
    # Create the asset directories in the shared folder so they're independant 
    # of our deployments.
    # 
    task :create, :roles => [ :app, :web ] do
      asset_directories.each do |dir|
        run "mkdir -p #{File.join(shared_path, "assets", dir)}"
      end
    end

    # Create a link from inside the current release to the shared asset 
    # directories.
    #
    task :symlink, :roles => [ :app, :web ] do
      asset_directories.each do |dir|
        run <<-CMD
        rm -rf #{latest_release}/#{dir} &&
        ln -s  #{shared_path}/assets/#{dir} #{latest_release}/#{dir}
        CMD
      end
    end
  end

  task :backup, :roles => [ :app ] do
    run "cd #{shared_path} && tar -czf assets-#{stage}.tgz assets/"
    get "#{shared_path}/assets-#{stage}.tgz", File.expand_path(File.dirname(__FILE__) + "/../../../../../#{stage}-assets-#{Time.as_backup_timestamp}.tgz")
  end
end

after :"deploy:update_code", :"assets:directories:symlink"

# Check with the dependency system that the shared asset directories exist.
#
on :load do
  asset_directories.each do |dir|
    depend :remote, :directory, "#{shared_path}/#{dir}"
  end
end