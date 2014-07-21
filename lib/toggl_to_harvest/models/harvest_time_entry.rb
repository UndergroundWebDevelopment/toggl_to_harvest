require "harvested"
require "date"

class Harvest::TogglTimeEntry < Harvest::TimeEntry

  skip_json_root true

  class << self
    # Generates a new harvest entry from a Toggl
    # time entry hash:
    def new_from_toggl_entry(toggl_entry_hash)
      data = {
        hours: (toggl_entry_hash["dur"].to_f / 1000 / 60 / 60).round(2), # Toggle returns durations in miliseconds.
        notes: toggl_entry_hash["description"] || toggl_entry_hash["task"] || toggl_entry_hash["project"],
      }

      # Tags get highest priority for matching:
      unless toggl_entry_hash["tags"].empty?
        toggl_entry_hash["tags"].each do |tag|
          if tag_mappings.key? tag
            data.merge! tag_mappings[tag]
            break
          end
        end
      end

      # Task mappings have second priority:
      unless data.key? :project_id
        if task_mappings.key? toggl_entry_hash["tid"]
          data.merge! task_mappings[toggl_entry_hash["tid"]]
        end
      end

      unless data.key? :project_id
        if project_mappings.key? toggl_entry_hash["pid"]
          data.merge! project_mappings[toggl_entry_hash["pid"]]
        end
      end

      new(data)
    end

    # Returns a hash, where keys are
    # toggle project ids and values are
    # a hash of the corresponding Harvest 
    # project and task ids.
    def project_mappings
      {
        5340162 => { project_id: 5705771, task_id: 2722871 }
      }
    end

    # Returns a hash, where keys are the task
    # id in Toggl and values are the project id
    # and task id in harvest to associate with.
    def task_mappings
      {
      }
    end

    # Returns a hash, where keys are tags in Toggl
    # and values are a hash of project_id & task_id
    # in harvest.
    def tag_mappings
      {
        "standup" => { project_id: 5705771, task_id: 2722871} 
      }
    end
  end

  def persist!
    harvest = Harvest.client(config["harvest_subdomain"], config["harvest_username"], config["harvest_password"])
    harvest.time.create(self)
  end

  def config
    @config ||= YAML.load_file(File.expand_path("~/.toggl-to-harvest.yml"))
    @config
  end
end
