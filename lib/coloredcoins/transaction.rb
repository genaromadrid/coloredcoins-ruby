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
      h = JSON.load(tx.to_json)
      @new_tx = Bitcoin::P::Tx.new(nil)
      @new_tx.ver, @new_tx.lock_time = (h['ver'] || h['version']), h['lock_time']
      ins  = h['in']  || h['inputs']
      outs = h['out'] || h['outputs']
      ins .each { |input|   @new_tx.add_in  Bitcoin::P::TxIn.from_hash(input)   }
      outs.each { |output|  @new_tx.add_out Bitcoin::P::TxOut.from_hash(output) }
      @new_tx.instance_eval{ @hash = hash_from_payload(@payload = to_payload) }
      @new_tx
    end

  end
end
