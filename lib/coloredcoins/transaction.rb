module Coloredcoins
  class Transaction
    attr_reader :tx

    def self.build_key(key)
      return key if key.is_a?(Array)
      key = Bitcoin::Key.from_base58(key) unless key.is_a?(Bitcoin::Key)
      key
    rescue RuntimeError => e
      raise InvalidKeyError, 'Invalid key' if e.message == 'Invalid version'
    end

    def self.build_sigs(key, sig_hash)
      key = [key] unless key.is_a?(Array)
      key.map { |k| k.sign(sig_hash) }
    end

    def initialize(hex)
      @tx = Bitcoin::P::Tx.new([hex].pack('H*'))
    end

    def to_hex
      raw_tx = Bitcoin::P::Tx.binary_from_json(new_tx.to_json)
      raw_tx.unpack('H*').first
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
      return response unless response[:txid]
      txid = response[:txid]
      txid.is_a?(Array) ? txid.first[:txid] : txid
    end
  end
end
