[![Build Status](https://travis-ci.org/cyli/logstash-output-slack.svg?branch=master)](https://travis-ci.org/cyli/logstash-output-slack)

Reviews of the code/contributions are very welcome (particularly with testing!), since I don't really know Ruby.

## Logstash Slack Output Plugin

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
        channel => [channel-name - optional]
        username => [slack username - optional]
        icon_emoji => [emoji, something like ":simple_smile:" - optional]
        icon_url => [icon url, would be overriden by icon_emoji - optional]
        format => [default is "%{message}", but used to format the text - optional]
        attachments => [an array of attachment maps as specified by the slack API - optional; if there is an "attachments" field in the event map and it is valid, it will override what is configured here, even if it's empty]
    }
}
```

## Contributing

All contributions are welcome: ideas, patches, documentation, bug reports, complaints, and even something you drew up on a napkin.

Programming is not a required skill. Whatever you've seen about open source and maintainers or community members  saying "send patches or die" - you will not see that here.

It is more important to the community that you are able to contribute.

For more information about contributing, see the [CONTRIBUTING](https://github.com/elastic/logstash/blob/master/CONTRIBUTING.md) file.
