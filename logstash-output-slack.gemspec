Gem::Specification.new do |s|
  s.name            = 'logstash-output-slack'
  s.version         = '2.1.1'
  s.licenses        = ['MIT','Apache License (2.0)']
  s.summary         = "Write events to Slack"
  s.description     = "This gem is a logstash plugin required to be installed on top of the Logstash core pipeline using $LS_HOME/bin/plugin install gemname. This gem is not a stand-alone program"
  s.authors         = ["Ying Li"]
  s.email           = 'cyli@ying.com'
  s.homepage        = "https://github.com/cyli/logstash-output-slack"
  s.require_paths   = ["lib"]

  # Files
  s.files = Dir["lib/**/*","spec/**/*","*.gemspec","*.md","CONTRIBUTORS","Gemfile","LICENSE","NOTICE.TXT", "vendor/jar-dependencies/**/*.jar", "vendor/jar-dependencies/**/*.rb", "VERSION", "docs/**/*"]

  # Tests
  s.test_files = s.files.grep(%r{^(test|spec|features)/})

  # Special flag to let us know this is actually a logstash plugin
  s.metadata = { "logstash_plugin" => "true", "logstash_group" => "output" }

  # Gem dependencies

  s.add_runtime_dependency "logstash-core-plugin-api", ">= 1.60", "<= 2.99"
  s.add_runtime_dependency "public_suffix", "< 1.5.0"
  
  s.add_runtime_dependency "logstash-codec-plain"
  s.add_runtime_dependency "rest-client", '~> 1.8', ">= 1.8.0"
  s.add_development_dependency "logstash-devutils"
  s.add_development_dependency "logstash-filter-json"
  s.add_development_dependency "logstash-input-generator"
  s.add_development_dependency "webmock", "~> 1.22", ">= 1.21.0"
end
