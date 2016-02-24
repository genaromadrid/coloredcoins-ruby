require 'simplecov'
SimpleCov.start do
  coverage_dir 'tmp/coverage'
  add_filter '/spec/'

  SimpleCov.at_exit do
    SimpleCov.result.format!
    system('open tmp/coverage/index.html') if RUBY_PLATFORM['darwin']
  end
end if ENV['COVERAGE']

require 'pry'
require 'rubygems'
require 'webmock/rspec'
require 'bundler/setup'
Bundler.require(:default)

WebMock.disable_net_connect!(allow_localhost: true)