require 'httparty'

class TogglReport
  include HTTParty

  base_uri "https://toggl.com/reports/api/v2"

  def details(*args)
    params = {
      basic_auth: {username: config["toggl_api_key"], password: "api_token"},
      query: {
        user_agent: "toggl_to_harvest Ruby gem",
        workspace_id: config["toggl_workspace_id"],
        user_ids: config["toggl_user_ids"].join(","),
      }
    }
    response = self.class.get("/details", params)

    if response.code == 200
      json_response = JSON.parse(response.body)
      json_response["data"]
    else
      raise "ERROR! Could not get time entries from Toggl API. Response status: #{response.code}\n #{response.body}"
    end
  end

  def config
    @config ||= YAML.load_file(File.expand_path("~/.toggl-to-harvest.yml"))
    @config
  end
end
