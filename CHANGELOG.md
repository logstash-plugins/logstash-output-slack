## 2.0.1
  - Update codec dependencies

## 2.0.0
  - Breaking: Updated plugin to use new Java Event APIs
  - relax logstash-core-plugin-api constrains
  - update .travis.yml

## 0.1.1 (https://github.com/cyli/logstash-output-slack/releases/tag/v0.1.1):
  - Added variable expansion to usernames and channel names ([#6](https://github.com/cyli/logstash-output-slack/pull/6))
  - Fixed bug when reporting malformed requests ([#3](https://github.com/cyli/logstash-output-slack/pull/3))
  - Test fixes since newer versions of logstash-core expects the values in
      the `add_field` hash to not be integers.
## 0.1.0(https://github.com/cyli/logstash-output-slack/releases/tag/v0.1.0):
  - initial version containing basic slack functionality
