# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'coloredcoins/version'

Gem::Specification.new do |spec|
  spec.name          = 'coloredcoins'
  spec.version       = Coloredcoins::VERSION
  spec.authors       = ['Genaro Madrid']
  spec.email         = ['genmadrid@gmail.com']
  spec.summary       = 'Ruby wrapper for coloredcoins.org'
  spec.homepage      = 'https://github.com/genaromadrid/coloredcoins-ruby'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'rest-client', '~> 1.7'
  spec.add_runtime_dependency 'json', '~> 1.8'
  spec.add_runtime_dependency 'bitcoin-ruby', '~> 0.0.8'

  spec.add_development_dependency 'bundler', '~> 1.6'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '3.1'
  spec.add_development_dependency 'pry-byebug', '~> 3.0'
  spec.add_development_dependency 'bump', '~> 0.5', '>= 0.5.3'
  spec.add_development_dependency 'rubocop',     '~> 0.36'
  spec.add_development_dependency 'simplecov',   '~> 0.11'
  spec.add_development_dependency 'webmock'
end
