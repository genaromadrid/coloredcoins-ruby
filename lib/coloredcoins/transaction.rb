require 'bitcoin'

module Coloredcoins
  class Transaction
    attr_reader :tx

    def initialize(hex)
      @tx = Bitcoin::P::Tx.new([hex].pack('H*'))
    end

    def to_hex
      raw_tx = Bitcoin::P::Tx.binary_from_json(new_tx.to_json)
      raw_tx.scrub.unpack('H*').first
    end

    def new_tx
      @new_tx = Bitcoin::P::Tx.new
      @new_tx.ver = tx.ver
      @new_tx.lock_time = tx.lock_time
      tx.in.each  { |input|   @new_tx.add_in(input)   }
      tx.out.each { |output|  @new_tx.add_out(output) }
      @new_tx
    end

    def broadcast
      response = Coloredcoins.broadcast(to_hex)
      return response[:txId] if response[:txId]
      response
    end
  end
end
