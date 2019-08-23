# frozen_string_literal: true

require 'bitcoin'
require 'coloredcoins/version'

module Coloredcoins
  autoload :API,         'coloredcoins/api'
  autoload :Connection,  'coloredcoins/connection'
  autoload :Transaction, 'coloredcoins/transaction'
  autoload :Multisig,    'coloredcoins/multisig'
  autoload :MultisigTx,  'coloredcoins/multisig_tx'

  attr_writer :api

  InvalidSignatureError = Class.new RuntimeError
  ConnectionError = Class.new StandardError
  InvalidKeyError = Class.new RuntimeError

  API_VERSION = 'v3'
  NETS = [
    MAINNET = 'mainnet',
    TESTNET = 'testnet'
  ].freeze

  def self.api
    @api ||= API.new(network, API_VERSION)
  end

  def self.network
    @network || MAINNET
  end

  def self.network=(network)
    @network = network
    @api = API.new(network, API_VERSION)
  end

  def self.method_missing(sym, *args, &block)
    return api.send(sym, *args, &block) if api.respond_to?(sym)

    super
  end

  def self.respond_to_missing?(method_name, include_private = false)
    api.respond_to?(method_name) || super
  end
end
