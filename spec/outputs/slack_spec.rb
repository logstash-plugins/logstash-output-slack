require_relative "../spec_helper"

describe LogStash::Outputs::Slack do

  let(:short_config) do <<-CONFIG
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
  end

  let(:long_config) do <<-CONFIG
      input {
        generator {
          message => "This message should show in slack"
          add_field => {"extra" => 3}
          count => 1
        }
      }

      output {
        slack {
          url => "http://requestb.in/r9lkbzr9"
          format => "%{message} %{extra}"
          channel => "mychannel"
          username => "slackbot"
          icon_emoji => ":chart_with_upwards_trend:"
          icon_url => "http://lorempixel.com/48/48"
        }
      }
  CONFIG
  end

  before do
    WebMock.disable_net_connect!
  end

  after do
    WebMock.reset!
    WebMock.allow_net_connect!
  end

  context "passes the right payload to slack" do
    it "uses all default values" do
      stub_request(:post, "requestb.in").
        to_return(:body => "", :status => 200,
                  :headers => { 'Content-Length' => 0 })

      expected_json = {
        :text => "This message should show in slack"
      }

      LogStash::Pipeline.new(short_config).run

      expect(a_request(:post, "http://requestb.in/r9lkbzr9").
        with(:body => "payload=#{CGI.escape(JSON.dump(expected_json))}",
             :headers => {
                'Content-Type' => 'application/x-www-form-urlencoded',
                'Accept'=> 'application/json',
                'User-Agent' => 'logstash-output-slack'
                })).
        to have_been_made.once
    end

    it "uses all provided values" do
      stub_request(:post, "requestb.in").
        to_return(:body => "", :status => 200,
                  :headers => { 'Content-Length' => 0 })

      expected_json = {
        :text => "This message should show in slack 3",
        :channel => "mychannel",
        :username => "slackbot",
        :icon_emoji => ":chart_with_upwards_trend:",
        :icon_url => "http://lorempixel.com/48/48"
      }

      LogStash::Pipeline.new(long_config).run

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
