# Use this file to easily define all of your cron jobs.
#

every 2.hours do
  ShiftReminderSweeperJob.perform_now
end
