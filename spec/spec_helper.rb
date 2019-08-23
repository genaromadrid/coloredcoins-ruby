# frozen_string_literal: true

require 'simplecov'
require 'coveralls'
SimpleCov.start do
  add_filter '/spec/'
end
Coveralls.wear!

require 'pry'
require 'rubygems'
require 'webmock/rspec'
require 'bundler/setup'
Bundler.require(:default)

WebMock.disable_net_connect!(allow_localhost: true)
