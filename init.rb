require 'redmine'


def init_redmine_log_hours_restrictions
  Dir::foreach(File.join(File.dirname(__FILE__), 'lib')) do |file|
    next unless /\.rb$/ =~ file
    require file
  end
end

if Rails::VERSION::MAJOR >= 5 and Rails::VERSION::MINOR >= 1
  reloader = ActiveSupport::Reloader
else
  reloader = ActionDispatch::Callbacks
end
reloader.to_prepare do
  Rails.logger.info "-------zzzzzzzzz--------------Preparing to patch TimeEntry"
  TimeEntry.send :include, TimeEntryLogHoursRestrictions::TimeEntryPatch
  Rails.logger.info "-----zzzzzzzzzzzzz---------------Patched TimeEntry"
end


Redmine::Plugin.register :redmine_log_hours_restrictions do
  name 'Redmine Log Hours Restrictions plugin'
  author 'Polelink'
  description 'Redmine plugin which allows configure the settings for logging.'
  version '0.0.1'
  url 'https://github.com/sunsolve/redmine_log_hours_restrictions'
  author_url 'https://polelink.com'
  requires_redmine :version_or_higher => '5.0'

  settings(:partial => 'settings/log_hours_restrictions_settings',
           :default => {
             :do_not_track_past_hours => true, 
             :do_not_track_hours_for_the_past_week => true, 
             :do_not_track_hours_for_the_past_month => true,
             :do_not_track_in_future => true,
         })
end

