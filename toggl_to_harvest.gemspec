# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'toggl_to_harvest/version'

Gem::Specification.new do |spec|
  spec.name          = "toggl_to_harvest"
  spec.version       = TogglToHarvest::VERSION
  spec.authors       = ["Alex Willemsma"]
  spec.email         = ["alex@undergroundwebdevelopment.com"]
  spec.summary       = %q{Syncronizes time tracked using Toggl to Harvest.}
  spec.description   = %q{Provides a command line tool to manage associations between Toggl projects and Harvest projects, and to synchronize time tracked in Toggl to the appropraite Harvest task.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "thor"
  spec.add_dependency "httparty"
  spec.add_dependency "harvested"

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
end
