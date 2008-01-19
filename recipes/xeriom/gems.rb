# TODO: Make sure Mongrel and MySQL gems get installed.
set :required_gems, [ :mongrel_cluster, :monit ]
set :gem_command, "gem"
set :gem_install_command, "install"
set :gem_prefix, ""
set :gem_options, "-y --no-ri --no-rdoc"

namespace :gems do
  task :configure, :roles => [ :app ] do
    as_administrator do
      fetch(:required_gems).each do |rubygem|
        sudo "#{gem_command} #{gem_install_command} #{gem_prefix}#{rubygem} #{gem_options}"
      end
    end
  end
end