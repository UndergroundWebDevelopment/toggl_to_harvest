require "toggl_to_harvest/version"
require "thor"
require "yaml"
require "toggl_to_harvest/models/toggl_report"
require "toggl_to_harvest/models/harvest_time_entry"

module TogglToHarvest
  class Script < Thor
    desc "sync", "Sync toggl timers to harvest."
    def sync
      time_logs = TogglReport.new.details
      time_logs.each do |time_log|
        if time_log["start"] && time_log["end"]
          begin
            entry = Harvest::TogglTimeEntry.new_from_toggl_entry(time_log)
            entry.persist!
            puts "Created time entry for Toggl time with id #{time_log["id"]} successfully! (#{entry.hours} hours)"
          rescue Harvest::HTTPError => e
            puts "Error, could not create a time entry from Toggl timer with id #{time_log["id"]}. Harvest returned the following error: #{e.message}"
          end
        end
      end
    end
  end
end
