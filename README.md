[![Build Status](https://travis-ci.org/cyli/logstash-output-slack.svg?branch=master)](https://travis-ci.org/cyli/logstash-output-slack)

Reviews of the code/contributions are very welcome (particularly with testing!), since I don't really know Ruby.

## Logstash Slack Output Plugin

Uses Slack [incoming webhooks API](https://api.slack.com/incoming-webhooks) to send log events to Slack.

Usage:

```
input {
    ...
}

filters {
    ...
}

output {
    ...
    slack {
        url => <YOUR SLACK WEBHOOK URL HERE>
        channel => [channel-name - optional]
        username => [slack username - optional]
        icon_emoji => [emoji, something like ":simple_smile:" - optional]
        icon_url => [icon url, would be overriden by icon_emoji - optional]
        format => [default is "%{message}", but used to format the text - optional]
        attachments => [an array of attachment maps as specified by the slack API - optional; if there is an "attachments" field in the event map and it is valid, it will override what is configured here, even if it's empty]
    }
}
```

### Changelog:
- [v0.1.2](https://github.com/cyli/logstash-output-slack/releases/tag/v0.1.2):
    - Added support for attachments
- [v0.1.1](https://github.com/cyli/logstash-output-slack/releases/tag/v0.1.1):
    - Added variable expansion to usernames and channel names ([#6](https://github.com/cyli/logstash-output-slack/pull/6))
    - Fixed bug when reporting malformed requests ([#3](https://github.com/cyli/logstash-output-slack/pull/3))
    - Test fixes since newer versions of logstash-core expects the values in
        the `add_field` hash to not be integers.
- [v0.1.0](https://github.com/cyli/logstash-output-slack/releases/tag/v0.1.0):
    - initial version containing basic slack functionality

### Installation on Logstash >= 1.5

In the logstash directory, run:  `bin/plugin install logstash-output-slack`, which will download and install the public gem.

#### To build your own gem and install:

1. `git clone <thisrepo>`
1. `bundle install`
1. `gem build logstash-output-slack.gemspec`
1. `cd <path to logstash>`
1. `logstash>1.5.0`: `bin/plugin install <path-to-your-built-gem>`

    On `logstash==1.5.0`, due to [this bug](https://github.com/elastic/logstash/issues/2674), installing from a local gem doesn't work. You will need to:

    1. Make sure that the `logstash-core` gem you've installed matches the exact beta 1.5 logstash version you are running.
    1. modify the logstash Gemfile to include the line `gem "logstash-output-slack", :path => <path_to_the_directory_your_gem_is_in>`
    1. `bin/plugin install --no-verify`

#### Verify that the plugin installed correctly
`bin/plugin list | grep logstash-output-slack`

#### Test that it works:
```
bin/logstash -e '
input { stdin {} }
output { slack { <your slack config here> }}'
```

And type some text in.  The same text should appear in the channel it's configured to go in.

### Installation on Logstash < 1.5

Gem-installing this plugin would only work on Logstash 1.5.  For Logstash < 1.5, you could just rename `lib` in this repo to `logstash`, and then run Logstash with `--pluginpath <path_to_this_repo>.

See the [flags](http://logstash.net/docs/1.4.2/flags) documentation for Logstash 1.4.
