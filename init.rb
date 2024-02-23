require 'redmine'


Redmine::Plugin.register :redmine_log_hours_restrictions do
  name 'Redmine Log Hours Restrictions plugin'
  author 'Polelink'
  description 'Redmine plugin which allows configure the settings for logging.'
  version '0.0.1'
  url 'https://github.com/sunsolve/redmine_log_hours_restrictions'
  author_url 'https://polelink.com'
  requires_redmine :version_or_higher => '4.0'

  settings(:partial => 'settings/log_hours_restrictions_settings',
           :default => {
             :do_not_track_past_hours => true, 
             :do_not_track_hours_for_the_past_week => true, 
             :do_not_track_hours_for_the_past_month => true,
             :do_not_track_in_future => true,
         })
end

Rails.configuration.to_prepare do
  Rails.logger.info "-------zzzzzzzzz--------------Preparing to patch TimeEntry"
  require_dependency 'time_entry'
  TimeEntry.send :include, TimeEntryLogHoursRestrictions::TimeEntryPatch
  Rails.logger.info "-----zzzzzzzzzzzzz---------------Patched TimeEntry"
end

