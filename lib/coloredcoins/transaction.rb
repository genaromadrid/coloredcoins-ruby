require 'bitcoin'

module Coloredcoins
  class Transaction
    attr_reader :tx

    def initialize(hex)
      @tx = Bitcoin::P::Tx.new([hex].pack('H*'))
    end

    def to_hex
      raw_tx = Bitcoin::P::Tx.binary_from_json(tx.to_json)
      raw_tx.scrub.unpack('H*').first
    end
  end
end
