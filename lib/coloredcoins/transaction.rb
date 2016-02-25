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

  protected

    def build_key(key)
      key = Bitcoin::Key.from_base58(key) unless key.is_a?(Bitcoin::Key)
      key
    rescue RuntimeError => e
      raise InvalidKeyError, 'Invalid key' if e.message == 'Invalid version'
    end

    def build_sigs(key, sig_hash)
      if key.is_a?(Array)
        sigs = []
        key.each do |k|
          sigs << k.sign(sig_hash)
        end
      else
        sigs = [key.sign(sig_hash)]
      end
      sigs
    end
  end
end
