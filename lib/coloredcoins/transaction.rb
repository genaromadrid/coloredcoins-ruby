require 'bitcoin'

module Coloredcoins
  class Transaction
    attr_reader :tx

    def initialize(hex)
      @tx = Bitcoin::P::Tx.new([hex].pack('H*'))
    end

  end
end
