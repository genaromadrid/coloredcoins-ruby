require 'bitcoin'

module Coloredcoins
  class Transaction
    attr_reader :tx

    def initialize(hex)
      @tx = Bitcoin::P::Tx.new([hex].pack('H*'))
    end

    def to_hex
      tx.scrub.unpack('H*').first
    end

  end
end
