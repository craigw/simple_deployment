set :scm_username, ENV['USER']
set :scm_auth_cache, true
set(:repository_root) { raise }
set(:deploy_to) { "/var/www/#{fetch(:fully_qualified_domain_name)}" }
set :deploy_via, :remote_cache
set(:repository) { "#{repository_root}trunk/#{application}/" }
set :create_tags_on_deploy, true
set(:repository_tag_base) { "#{repository_root}tags/#{application}/" }

namespace :subversion do
  task :tag_release do
    if fetch(:create_tags_on_deploy)
      tag = "#{fetch(:repository_tag_base)}#{Time.as_subversion_tag}_#{stage}"
      logger.info "Tagging this release as #{tag}"
      tag_does_not_exist = `svn ls #{tag} 2> /dev/null` == ""
      if tag_does_not_exist
        tag_command = "svn copy \
        -m '#{application} deployed to #{stage}' \
        #{repository} #{tag}"
        `#{tag_command}`
      else
        logger.important "Could not tag release as #{tag} because tag exists"
      end
    end
  end
end

# Tag the release after each deployment so we can track what's deployed
# and where to.
#
after :deploy, :"subversion:tag_release"
after :"deploy:initial", :"subversion:tag_release"
after :"deploy:migrations", :"subversion:tag_release"