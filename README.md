[![Build Status](https://travis-ci.org/cyli/logstash-output-slack.svg?branch=master)](https://travis-ci.org/cyli/logstash-output-slack)

# Logstash Slack Output Plugin

[![Build
Status](http://build-eu-00.elastic.co/view/LS%20Plugins/view/LS%20Outputs/job/logstash-plugin-output-slack-unit/badge/icon)](http://build-eu-00.elastic.co/view/LS%20Plugins/view/LS%20Outputs/job/logstash-plugin-output-slack-unit/)

This is a plugin for [Logstash](https://github.com/elasticsearch/logstash) that pushes log events to [Slack](www.slack.com) using their [incoming webhooks API](https://api.slack.com/incoming-webhooks).

It is fully free and fully open source. The license is Apache 2.0, meaning you are pretty much free to use it however you want in whatever way.

=======
Logstash provides infrastructure to automatically generate documentation for this plugin. We use the asciidoc format to write documentation so any comments in the source code will be first converted into asciidoc and then into html. All plugin documentation are placed under one [central location](http://www.elastic.co/guide/en/logstash/current/).

- For formatting code or config example, you can use the asciidoc `[source,ruby]` directive
- For more asciidoc formatting tips, see the excellent reference here https://github.com/elastic/docs#asciidoc-guide.

## Need Help?

Need help? Try #logstash on freenode IRC or the https://discuss.elastic.co/c/logstash discussion forum.

## Usage

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

## Developing

### 1. Plugin Developement and Testing

#### Code
- To get started, you'll need JRuby with the Bundler gem installed.

- Create a new plugin or clone and existing from the GitHub [logstash-plugins](https://github.com/logstash-plugins) organization. We also provide [example plugins](https://github.com/logstash-plugins?query=example).

- Install dependencies
```sh
bundle install
```

#### Test

- Update your dependencies

```sh
bundle install
```

- Run tests

```sh
bundle exec rspec
```

## Installation on Logstash >= 1.5

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

## Contributing

All contributions are welcome: ideas, patches, documentation, bug reports, complaints, and even something you drew up on a napkin.

Programming is not a required skill. Whatever you've seen about open source and maintainers or community members  saying "send patches or die" - you will not see that here.

It is more important to the community that you are able to contribute.

For more information about contributing, see the [CONTRIBUTING](https://github.com/elastic/logstash/blob/master/CONTRIBUTING.md) file.
