require 'redmine'
require 'date'
require 'active_support'

require_dependency 'time_entry'

module TimeEntryRestrictionsPatch
   extend ActiveSupport::Concern

  included do
    before_save :check_spent_on_restrictions
  end

  private

  def check_spent_on_restrictions
    today = Date.today
    monday = today - (today.wday - 1) % 7
    saturday = today + (6 - today.wday) % 7
    sunday = today + (7 - today.wday) % 7

    logger.info("-----------------------------------wwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwww---------------------------------------")

    # 不允许未来的日期
    if Setting.plugin_redmine_log_hours_restrictions['do_not_track_in_future'] && spent_on > today
      errors.add :spent_on, I18n.t(:time_entry_restriction_future_day)
      throw(:abort)
    end

    # 不允许周六
    if Setting.plugin_redmine_log_hours_restrictions['do_not_track_on_saturday'] && spent_on == saturday
      errors.add :spent_on, I18n.t(:time_entry_restriction_saturday)
      throw(:abort)
    end

    # 不允许周日
    if Setting.plugin_redmine_log_hours_restrictions['do_not_track_on_sunday'] && spent_on == sunday
      errors.add :spent_on, I18n.t(:time_entry_restriction_sunday)
      throw(:abort)
    end


    # 不允许上个月之前的日期）
    if Setting.plugin_redmine_log_hours_restrictions['do_not_track_hours_for_the_past_month'] and spent_on < Date.today.at_beginning_of_month
      errors.add :spent_on, I18n.t(:time_entry_restiction_mounth)
      throw(:abort)
    # 不允许上周之前的日期 
    elsif Setting.plugin_redmine_log_hours_restrictions['do_not_track_hours_for_the_past_week'] and spent_on < monday
      errors.add :spent_on, I18n.t(:time_entry_restiction_week)
      throw(:abort)
    # 不允许当日之前的日期 
    elsif Setting.plugin_redmine_log_hours_restrictions['do_not_track_past_hours'] and spent_on < today
      errors.add :spent_on, I18n.t(:time_entry_restiction_day)
      throw(:abort)
    end
  end
end
