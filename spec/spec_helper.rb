require 'coveralls'
Coveralls.wear!

require 'simplecov'
SimpleCov.start do
  add_filter '/spec/'
end

require 'pry'
require 'rubygems'
require 'webmock/rspec'
require 'bundler/setup'
Bundler.require(:default)

WebMock.disable_net_connect!(allow_localhost: true)
