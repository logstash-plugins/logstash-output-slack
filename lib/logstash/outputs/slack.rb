require "logstash/outputs/base"
require "logstash/namespace"

class LogStash::Outputs::Slack < LogStash::Outputs::Base

  config_name "slack"

  milestone 1

  config :url, :validate => :string, :required => true

  config :from, :validate => :string, :default => "logstash"

  config :format, :validate => :string, :required => true

  public
  def register
    require "ftw"

    @agent = FTW::Agent.new

    @content_type = "application/x-www-form-urlencoded"
  end

  public
  def receive(event)
    return unless output?(event)

    begin
      request = @agent.post(@url)
      request["Content-Type"] = @content_type
      request.body = [
        "payload={\"text\": \"",
        CGI.escape(event.sprintf(@format)),
        "\"}"
      ].join("")

      response = @agent.execute(request)

      rbody = ""
      response.read_body { |c| rbody << c }
    rescue Exception => e
      @logger.warn("Unhandled exception")
    end
  end

end
