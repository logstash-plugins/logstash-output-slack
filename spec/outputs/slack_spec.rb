require_relative "../spec_helper"

describe LogStash::Outputs::Slack do

  subject { described_class.new(config) }
  let(:config) { { } }
  let(:event) { LogStash::Event.new(data) }
  let(:data) { {} }

  # Actually do most of the boiler plate by stubbing out the request, running
  # the logstash pipeline, and asserting that a request was made with the
  # expected JSON.
  def test_one_event(event, expected_json, expected_url = "http://requestb.in/r9lkbzr9")
    stub_request(:post, "requestb.in").
      to_return(:body => "", :status => 200,
                :headers => { 'Content-Length' => 0 })

    subject.receive(event)

    expect(a_request(:post, expected_url).
           with(:body => "payload=#{CGI.escape(JSON.dump(expected_json))}",
                :headers => {
                  'Content-Type' => 'application/x-www-form-urlencoded',
                  'Accept'=> 'application/json',
                  'User-Agent' => 'logstash-output-slack'
                  })).
           to have_been_made.once
  end

  before(:each) do
    subject.register
    WebMock.disable_net_connect!
  end

  after(:each) do
    WebMock.reset!
    WebMock.allow_net_connect!
  end

  context "passes the right payload to slack" do
    context "simple" do
      let(:data) { { "message" => "This message should show in slack" } }
      let(:config) { { "url" => "http://requestb.in/r9lkbzr9" } }

      it "uses all default values" do
        expected_json = { :text => "This message should show in slack" }
        test_one_event(event, expected_json)
      end
    end

    context "with multiple interpolations" do
      let(:data) { {
        "message" => "This message should show in slack",
        "x" => "3",
        "channelname" => "mychannel",
        "username" => "slackbot"
      } }

      let(:config) { {
        "url" => "http://requestb.in/r9lkbzr9",
        "format" => "%{message} %{x}",
        "channel" => "%{channelname}",
        "username" => "%{username}",
        "icon_emoji" => ":chart_with_upwards_trend:",
        "icon_url" => "http://lorempixel.com/48/48",
      } }

      it "uses and formats all provided values" do
        expected_json = {
          :text => "This message should show in slack 3",
          :channel => "mychannel",
          :username => "slackbot",
          :icon_emoji => ":chart_with_upwards_trend:",
          :icon_url => "http://lorempixel.com/48/48"
        }
        test_one_event(event, expected_json)
      end
    end

    context "if the message contains no interpolations" do

      let(:data) { {
        "message" => "This message should show in slack"
      } }

      let(:config) { {
        "url" => "http://requestb.in/r9lkbzr9",
        "format" => "Unformatted message",
        "channel" => "mychannel",
        "username" => "slackbot",
        "icon_emoji" => ":chart_with_upwards_trend:",
        "icon_url" => "http://lorempixel.com/48/48"
      } }

      it "uses and formats all provided values" do
        expected_json = {
          :text => "Unformatted message",
          :channel => "mychannel",
          :username => "slackbot",
          :icon_emoji => ":chart_with_upwards_trend:",
          :icon_url => "http://lorempixel.com/48/48"
        }
        test_one_event(event, expected_json)
      end
    end

    describe "default attachements" do
      let(:config) { {
        "url" => "http://requestb.in/r9lkbzr9",
        "attachments" => [{ "image_url" => "http://example.com/image.png" }]
      } }

      context "when none are in the event" do
        let(:data) { { "message" => "This message should show in slack" } }
        it "uses the default" do
          expected_json = {
            :text => "This message should show in slack",
            :attachments => [{:image_url => "http://example.com/image.png"}]
          }
          test_one_event(event, expected_json)
        end
      end

      context "when using multiple attachments" do
        let(:data) { { "message" => "This message should show in slack" } }
        let(:config) { {
          "url" => "http://requestb.in/r9lkbzr9",
          "attachments" => [
            {"image_url" => "http://example.com/image1.png"},
            {"image_url" => "http://example.com/image2.png"}
          ]
        } }
        it "sends them" do
          expected_json = {
            :text => "This message should show in slack",
            :attachments => [{:image_url => "http://example.com/image1.png"},
                             {:image_url => "http://example.com/image2.png"}]
          }
          test_one_event(event, expected_json)
        end
      end
    end

    context "empty default attachments" do
      let(:data) { {
        "message" => "This message should show in slack"
      }}

      let(:config) { {
        "url" => "http://requestb.in/r9lkbzr9",
        "attachments" => []
      }}

      it "are ignored" do
        expected_json = {
          :text => "This message should show in slack"
        }
        test_one_event(event, expected_json)
      end
    end

    context "when both event attachments and default attachments are set" do

      let(:data) { {
        "message" => "This message should show in slack",
        "attachments" => [{"thumb_url" => "http://other.com/thumb.png"}]
      } }

      let(:config) { {
        "url" => "http://requestb.in/r9lkbzr9",
        "attachments" => [
          {"image_url" => "http://example.com/image1.png"},
          {"image_url" => "http://example.com/image2.png"}
        ]
      } }

      it "event attachements prevail" do
        expected_json = {
          :text => "This message should show in slack",
          :attachments => [{:thumb_url => "http://other.com/thumb.png"}]
        }
        test_one_event(event, expected_json)
      end
    end

    context "if event attachments empty" do

      let(:data) { {
        "message" => "This message should show in slack",
        "attachments" => []
      } }

      let(:config) { {
        "url" => "http://requestb.in/r9lkbzr9",
        "attachments" => [
          {"image_url" => "http://example.com/image1.png"},
          {"image_url" => "http://example.com/image2.png"}
        ]
      } }

      it "erases default attachments" do
        expected_json = {
          :text => "This message should show in slack"
        }
        test_one_event(event, expected_json)
      end
    end

    context "when event attachements field isn't an array" do
      let(:data) { {
        "message" => "This message should show in slack",
        "attachments" => "baddata"
      } }

      let(:config) { {
        "url" => "http://requestb.in/r9lkbzr9",
        "attachments" => [
          {"image_url" => "http://example.com/image.png"}
        ]
      } }


      it "is ignored" do
        expected_json = {
          :text => "This message should show in slack",
          :attachments => [{:image_url => "http://example.com/image.png"}]
        }
        test_one_event(event, expected_json)
      end
    end

    context "when attachements contain interpolations" do
      let(:data) { {
        "message" => "This message should show in slack",
        "x" => "3",
        "image" => "http://example.com/image.png",
        "textquot" => "Text with \"quotation marks\"",
      } }

      let(:config) { {
        "url" => "http://requestb.in/r9lkbzr9",
        "attachments" => [
          {"image_url" => "%{image}",
          "textquot" => "%{textquot}"
          }
        ]
      } }

      it "uses and formats all provided values" do
        expected_json = {
          :text => "This message should show in slack",
          :attachments => [{
            :image_url => "http://example.com/image.png",
            :textquot => "Text with \"quotation marks\""
          }]
        }
        test_one_event(event, expected_json)
      end
    end
  end

  describe "interpolation in url field" do
    let(:expected_url) { "http://incoming-webhook.example.com" }

    let(:event) {
      event = LogStash::Event.new("message" => "This message should show in slack")
      event.set("[@metadata][slack_url]", "#{expected_url}")
      event
    }

    let(:config) { {
      "url" => "%{[@metadata][slack_url]}",
      "attachments" => [
        {"image_url" => "http://example.com/image.png"}
      ]
    } }

    it "allows interpolation in url field" do
      expected_json = {
        :text => "This message should show in slack",
        :attachments => [{:image_url => "http://example.com/image.png"}]
      }
      test_one_event(event, expected_json, expected_url)
    end
  end
end
