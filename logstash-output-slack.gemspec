Gem::Specification.new do |s|
  s.name            = 'logstash-output-slack'
  s.version         = '2.0.0'
  s.licenses        = ['MIT','Apache License (2.0)']
  s.summary         = "Write events to Slack"
  s.description     = "This gem is a logstash plugin required to be installed on top of the Logstash core pipeline using $LS_HOME/bin/plugin install gemname. This gem is not a stand-alone program"
  s.authors         = ["Ying Li"]
  s.email           = 'cyli@ying.com'
  s.homepage        = "https://github.com/cyli/logstash-output-slack"
  s.require_paths   = ["lib"]

  # Files
  s.files = `git ls-files`.split($\)

  # Tests
  s.test_files = s.files.grep(%r{^(test|spec|features)/})

  # Special flag to let us know this is actually a logstash plugin
  s.metadata = { "logstash_plugin" => "true", "logstash_group" => "output" }

  # Gem dependencies

  s.add_runtime_dependency "logstash-core-plugin-api", ">= 1.60", "<= 2.99"
  
  s.add_runtime_dependency "logstash-codec-plain", "~> 2.0.0", ">= 1.0.0"
  s.add_runtime_dependency "rest-client", '~> 1.8', ">= 1.8.0"
  s.add_development_dependency "logstash-devutils", "~> 0.0.16"
  s.add_development_dependency "logstash-filter-json", "~> 2.0.1", ">= 1.0.1"
  s.add_development_dependency "logstash-input-generator", "~> 2.0.1", ">= 1.0.0"
  s.add_development_dependency "webmock", "~> 1.22", ">= 1.21.0"
end
