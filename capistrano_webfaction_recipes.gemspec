# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'capistrano_webfaction_recipes/version'

Gem::Specification.new do |spec|
  spec.name          = "capistrano_webfaction_recipes"
  spec.version       = CapistranoWebfactionRecipes::VERSION
  spec.authors       = ["Fire-Dragon-DoL"]
  spec.email         = ["francesco.belladonna@gmail.com"]
  spec.description   = "Gem container for some nice webfaction recipes plus a standard deploy file that can be created with a generator"
  spec.summary       = "A collection of recipes to handle webfaction shared hosting"
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_dependency "capistrano", "2.15.4"
end
