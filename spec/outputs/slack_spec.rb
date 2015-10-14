require_relative "../spec_helper"

describe LogStash::Outputs::Slack do

  # Actually do most of the boiler plate by stubbing out the request, running
  # the logstash pipeline, and asserting that a request was made with the
  # expected JSON.
  def test_one_event(logstash_config, expected_json)
    stub_request(:post, "requestb.in").
      to_return(:body => "", :status => 200,
                :headers => { 'Content-Length' => 0 })

    LogStash::Pipeline.new(logstash_config).run

    expect(a_request(:post, "http://requestb.in/r9lkbzr9").
           with(:body => "payload=#{CGI.escape(JSON.dump(expected_json))}",
                :headers => {
                  'Content-Type' => 'application/x-www-form-urlencoded',
                  'Accept'=> 'application/json',
                  'User-Agent' => 'logstash-output-slack'
                  })).
           to have_been_made.once
  end

  before do
    WebMock.disable_net_connect!
  end

  after do
    WebMock.reset!
    WebMock.allow_net_connect!
  end

  context "passes the right payload to slack and" do
    it "uses all default values" do
      expected_json = {
        :text => "This message should show in slack"
      }
      logstash_config = <<-CONFIG
          input {
            generator {
              message => "This message should show in slack"
              count => 1
            }
          }
          output {
            slack {
              url => "http://requestb.in/r9lkbzr9"
            }
          }
      CONFIG

      test_one_event(logstash_config, expected_json)
    end

    it "uses and formats all provided values" do
      expected_json = {
        :text => "This message should show in slack 3",
        :channel => "mychannel",
        :username => "slackbot",
        :icon_emoji => ":chart_with_upwards_trend:",
        :icon_url => "http://lorempixel.com/48/48"
      }

      logstash_config = <<-CONFIG
          input {
            generator {
              message => "This message should show in slack"
              add_field => {"x" => "3"
                            "channelname" => "mychannel"
                            "username" => "slackbot"}
              count => 1
            }
          }
          output {
            slack {
              url => "http://requestb.in/r9lkbzr9"
              format => "%{message} %{x}"
              channel => "%{channelname}"
              username => "%{username}"
              icon_emoji => ":chart_with_upwards_trend:"
              icon_url => "http://lorempixel.com/48/48"
            }
          }
      CONFIG

      test_one_event(logstash_config, expected_json)
    end

    it "uses and formats all provided values" do
      expected_json = {
        :text => "Unformatted message",
        :channel => "mychannel",
        :username => "slackbot",
        :icon_emoji => ":chart_with_upwards_trend:",
        :icon_url => "http://lorempixel.com/48/48"
      }

      logstash_config = <<-CONFIG
          input {
            generator {
              message => "This message should show in slack"
              count => 1
            }
          }
          output {
            slack {
              url => "http://requestb.in/r9lkbzr9"
              format => "Unformatted message"
              channel => "mychannel"
              username => "slackbot"
              icon_emoji => ":chart_with_upwards_trend:"
              icon_url => "http://lorempixel.com/48/48"
            }
          }
      CONFIG

      test_one_event(logstash_config, expected_json)
    end

    it "uses the default attachments if none are in the event" do
      stub_request(:post, "requestb.in").
        to_return(:body => "", :status => 200,
                  :headers => { 'Content-Length' => 0 })

      expected_json = {
        :text => "This message should show in slack",
        :attachments => [{:image_url => "http://example.com/image.png"}]
      }

      LogStash::Pipeline.new(<<-CONFIG
          input {
            generator {
              message => "This message should show in slack"
              count => 1
            }
          }
          output {
            slack {
              url => "http://requestb.in/r9lkbzr9"
              attachments => [
                {image_url => "http://example.com/image.png"}
              ]
            }
          }
      CONFIG
      ).run

      expect(a_request(:post, "http://requestb.in/r9lkbzr9").
        with(:body => "payload=#{CGI.escape(JSON.dump(expected_json))}",
             :headers => {
                'Content-Type' => 'application/x-www-form-urlencoded',
                'Accept'=> 'application/json',
                'User-Agent' => 'logstash-output-slack'
                })).
        to have_been_made.once
    end

    it "ignores empty default attachments" do
      stub_request(:post, "requestb.in").
        to_return(:body => "", :status => 200,
                  :headers => { 'Content-Length' => 0 })

      expected_json = {
        :text => "This message should show in slack"
      }

      LogStash::Pipeline.new(<<-CONFIG
          input {
            generator {
              message => "This message should show in slack"
              count => 1
            }
          }
          output {
            slack {
              url => "http://requestb.in/r9lkbzr9"
              attachments => []
            }
          }
      CONFIG
      ).run

      expect(a_request(:post, "http://requestb.in/r9lkbzr9").
        with(:body => "payload=#{CGI.escape(JSON.dump(expected_json))}",
             :headers => {
                'Content-Type' => 'application/x-www-form-urlencoded',
                'Accept'=> 'application/json',
                'User-Agent' => 'logstash-output-slack'
                })).
        to have_been_made.once
    end

    it "uses event attachments over default attachments" do
      stub_request(:post, "requestb.in").
        to_return(:body => "", :status => 200,
                  :headers => { 'Content-Length' => 0 })

      attachments =

      expected_json = {
        :text => "This message should show in slack",
        :attachments => [{:thumb_url => "http://other.com/thumb.png"}]
      }

      # add_field only takes string values
      LogStash::Pipeline.new(<<-CONFIG
          input {
            generator {
              message => "This message should show in slack"
              count => 1
              add_field => {
                attachments => '[{"thumb_url": "http://other.com/thumb.png"}]'
              }
            }
          }
          filter {
            json {
              source => "attachments"
              target => "attachments"
            }
          }
          output {
            slack {
              url => "http://requestb.in/r9lkbzr9"
              attachments => [
                {image_url => "http://example.com/image.png"}
              ]
            }
          }
      CONFIG
      ).run

      expect(a_request(:post, "http://requestb.in/r9lkbzr9").
        with(:body => "payload=#{CGI.escape(JSON.dump(expected_json))}",
             :headers => {
                'Content-Type' => 'application/x-www-form-urlencoded',
                'Accept'=> 'application/json',
                'User-Agent' => 'logstash-output-slack'
                })).
        to have_been_made.once
    end

    it "erases default attachments if event attachments empty" do
      stub_request(:post, "requestb.in").
        to_return(:body => "", :status => 200,
                  :headers => { 'Content-Length' => 0 })

      attachments =

      expected_json = {
        :text => "This message should show in slack"
      }

      # add_field only takes string values
      LogStash::Pipeline.new(<<-CONFIG
          input {
            generator {
              message => "This message should show in slack"
              count => 1
              add_field => {attachments => '[]'}
            }
          }
          filter {
            json {
              source => "attachments"
              target => "attachments"
            }
          }
          output {
            slack {
              url => "http://requestb.in/r9lkbzr9"
              attachments => [
                {image_url => "http://example.com/image.png"}
              ]
            }
          }
      CONFIG
      ).run

      expect(a_request(:post, "http://requestb.in/r9lkbzr9").
        with(:body => "payload=#{CGI.escape(JSON.dump(expected_json))}",
             :headers => {
                'Content-Type' => 'application/x-www-form-urlencoded',
                'Accept'=> 'application/json',
                'User-Agent' => 'logstash-output-slack'
                })).
        to have_been_made.once
    end

    it "ignores event attachment if not array" do
      stub_request(:post, "requestb.in").
        to_return(:body => "", :status => 200,
                  :headers => { 'Content-Length' => 0 })

      attachments =

      expected_json = {
        :text => "This message should show in slack",
        :attachments => [{:image_url => "http://example.com/image.png"}]
      }

      # add_field only takes string values
      LogStash::Pipeline.new(<<-CONFIG
          input {
            generator {
              message => "This message should show in slack"
              count => 1
              add_field => {attachments => "baddata"}
            }
          }
          output {
            slack {
              url => "http://requestb.in/r9lkbzr9"
              attachments => [
                {image_url => "http://example.com/image.png"}
              ]
            }
          }
      CONFIG
      ).run

      expect(a_request(:post, "http://requestb.in/r9lkbzr9").
        with(:body => "payload=#{CGI.escape(JSON.dump(expected_json))}",
             :headers => {
                'Content-Type' => 'application/x-www-form-urlencoded',
                'Accept'=> 'application/json',
                'User-Agent' => 'logstash-output-slack'
                })).
        to have_been_made.once
    end
  end
end
