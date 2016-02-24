require 'coloredcoins/version'

module Coloredcoins
  autoload :API,        'coloredcoins/api'
  autoload :Connection, 'coloredcoins/connection'
  autoload :Transaction, 'coloredcoins/transaction'
  autoload :MultisigTx, 'coloredcoins/multisig_tx'

  attr_writer :api

  API_VERSION = 'v3'
  NETS = [
    MAINNET = 'mainnet',
    TESTNET = 'testnet'
  ]

  def self.api
    @api ||= API.new(network:network, api_version:API_VERSION)
  end

  def self.network
    @network || MAINNET
  end

  def self.network=(network)
    @network = network
    @api = API.new(network:network, api_version:API_VERSION)
  end

  def self.method_missing(sym, *args, &block)
    api.send(sym, *args, &block)
  end
end
