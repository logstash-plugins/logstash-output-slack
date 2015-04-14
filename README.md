[![Build Status](https://travis-ci.org/cyli/logstash-output-slack.svg?branch=master)](https://travis-ci.org/cyli/logstash-output-slack)

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
        channel => [channel-name - this is optional]
        username => [slack username - this is optional]
        icon_emoji => [emoji, something like ":simple_smile:" - optional]
        icon_url => [icon url, would be overriden by icon_emoji - optional]
        format => [default is "%{message}", but used to format the text - optional]
    }
}
```

Not supported yet: attachments

### Installation on Logstash >= 1.5

In the logstash directory, run:  `bin/plugin install logstash-output-slack`

#### To build your own gem and install:

1. `git clone <thisrepo>`
1. `bundle install`
1. `gem build logstash-output-slack.gemspec`

You should just be able to do `bin/plugin install <path-to-your-built-gem>`, but due to [this bug](https://github.com/elastic/logstash/issues/2674) installing from a local gem doesn't work right now.

You need to:

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

### Installation on Logstash < 1.4

Gem-installing this plugin would only work on Logstash 1.5.  For Logstash < 1.5, you could just rename `lib` in this repo to `logstash`, and then run Logstash with `--pluginpath <path_to_this_repo>.

See the [flags](http://logstash.net/docs/1.4.2/flags) documentation for Logstash 1.4.
