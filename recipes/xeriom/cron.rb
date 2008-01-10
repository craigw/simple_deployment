set :cron_tasks_path, File.expand_path(File.dirname(__FILE__) + '/../../../../../config/cron/*.cron.erb')

namespace :cron do
  # TODO: Handle Cron tasks that should only be run on certain hosts eg
  # DB backup should only be run on the db hosts, and probably only on the
  # primary one at that...
  #
  task :configure, :except => { :no_release => true } do
    cron_task_templates = Dir[fetch(:cron_tasks_path)]
    cron_stanza_start_sentinel = "\#\#\# Start #{application} #{stage} tasks"
    cron_stanza_stop_sentinel  = "\#\#\# Stop #{application} #{stage} tasks"
    cron_entries = []
    cron_entries << cron_stanza_start_sentinel
    cron_entries << "\# Last changed: #{Time.now.to_s}"
    cron_entries << "\# Everything from the start line above to the end line"
    cron_entries << "\# below is automatically generated and likely to get"
    cron_entries << "\# clobbered as part of the next update. Enjoy!"

    cron_task_templates.collect do |cron_task_template|
      template = File.read(cron_task_template)
      cron_task = ERB.new(template).result(binding)
      cron_entries << cron_task
    end

    cron_entries << cron_stanza_stop_sentinel
    run "crontab -l 2>/dev/null | sed '/^#{cron_stanza_start_sentinel}/,/^#{cron_stanza_stop_sentinel}/d' > ~/cron.tmp"
    cron_entries.each do |cron_entry|
      run "echo #{cron_entry.escape_for_shell} >> ~/cron.tmp"
    end
    run "crontab ~/cron.tmp"
  end
end

# Update Cron tasks on every update in case new ones have been added (or old 
# ones removed).
#
after :"deploy:update_code", :"cron:configure"