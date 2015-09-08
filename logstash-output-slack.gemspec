Gem::Specification.new do |s|
  s.name            = 'logstash-output-slack'
  s.version         = '0.1.1'
  s.licenses        = ['MIT','Apache License (2.0)']
  s.summary         = "Write events to Slack"
  s.description     = "This gem is a logstash plugin required to be installed on top of the Logstash core pipeline using $LS_HOME/bin/plugin install gemname. This gem is not a stand-alone program"
  s.authors         = ["Ying Li"]
  s.email           = 'cyli@twistedmatrix.com'
  s.require_paths   = ["lib"]

  # Files
  s.files = `git ls-files`.split($\)

  # Tests
  s.test_files = s.files.grep(%r{^(test|spec|features)/})

  # Special flag to let us know this is actually a logstash plugin
  s.metadata = { "logstash_plugin" => "true", "logstash_group" => "output" }

  # Gem dependencies
  s.add_runtime_dependency "logstash-core", ">= 1.4.0", "< 2.0.0"
  s.add_runtime_dependency "logstash-codec-plain"
  s.add_runtime_dependency "rest-client"
  s.add_development_dependency "logstash-devutils"
  s.add_development_dependency "logstash-input-generator"
  s.add_development_dependency "webmock"

  # Jar dependencies
  s.requirements << "jar 'org.elasticsearch:elasticsearch', '1.4.0'"
  s.add_runtime_dependency "jar-dependencies", ">= 0.1.7"
end
