# encoding: utf-8
require "logstash/outputs/base"
require "logstash/namespace"

class LogStash::Outputs::Slack < LogStash::Outputs::Base
  config_name "slack"
  milestone 1

  # The incoming webhook URI needed to post a message
  config :url, :validate => :string, :required => true

  # The text to post in slack
  config :format, :validate => :string, :default => "%{message}"

  # The channel to post to
  config :channel, :validate => :string

  # The username to use for posting
  config :username, :validate => :string

  # Emoji icon to use
  config :icon_emoji, :validate => :string

  # Icon URL to use
  config :icon_url, :validate => :string

  # Attachments array as described https://api.slack.com/docs/attachments
  config :attachments, :validate => :array

  public
  def register
    require 'rest-client'
    require 'cgi'
    require 'json'

    @content_type = "application/x-www-form-urlencoded"
  end # def register

  public
  def receive(event)
    return unless output?(event)

    payload_json = Hash.new
    payload_json['text'] = event.sprintf(@format)
    url = event.sprintf(@url)

    if not @channel.nil?
      payload_json['channel'] = event.sprintf(@channel)
    end

    if not @username.nil?
      payload_json['username'] = event.sprintf(@username)
    end

    if not @icon_emoji.nil?
      payload_json['icon_emoji'] = @icon_emoji
    end

    if not @icon_url.nil?
      payload_json['icon_url'] = @icon_url
    end

    if @attachments and @attachments.any?
      payload_json['attachments'] = @attachments.map { |x| JSON.parse(event.sprintf(JSON.dump(x))) }
    end
    if event.include?('attachments') and event.get('attachments').is_a?(Array)
      if event.get('attachments').any?
        # need to convert possibly from Java objects to Ruby Array, because
        # JSON dumps does not work well with Java ArrayLists, etc.
        rubified = JSON.parse(event.to_json())
        payload_json['attachments'] = rubified['attachments']
      else
        payload_json.delete('attachments')
      end
    end

    begin
      RestClient.proxy = ENV['http_proxy']      
      RestClient.post(
        url,
        "payload=#{CGI.escape(JSON.dump(payload_json))}",
        :accept => "application/json",
        :'User-Agent' => "logstash-output-slack",
        :content_type => @content_type) { |response, request, result, &block|
          if response.code != 200
            @logger.warn("Got a #{response.code} response: #{response}")
          end
        }
    rescue Exception => e
      @logger.warn("Unhandled exception", :exception => e,
                   :stacktrace => e.backtrace)
    end
  end # def receive
end # class LogStash::Outputs::Slack
