module Coloredcoins
  class MultisigTx < Transaction
    attr_accessor :m, :pub_keys, :key

    def self.build(tx_hex)
      transaction = MultisigTx.new(tx_hex)
      yield transaction
      transaction
    end

    def sign(key)
      check
      key, pub_key_hex = build_key(key)
      tx.inputs.each_with_index do |input, i|
        sig = key.sign(redeem_script)
        public_script = Bitcoin::Script.to_signature_pubkey_script(sig, pub_key_hex)
        input.script_sig = public_script
        raise Coloredcoins::InvalidSignatureError unless valid_sig?(i, public_script)
      end
      true
    end

    def redeem_script
      @redeem_script ||= Bitcoin::Script.to_p2sh_multisig_script(m, *pub_keys).last
    end

    def address
      @address ||= Bitcoin.hash160_to_p2sh_address(Bitcoin.hash160(redeem_script.hth))
    end

    def broadcast
      response = Coloredcoins.broadcast(to_hex)
      response[:txId]
    end

  private

    def build_key(key)
      key = Bitcoin::Key.from_base58(key) unless key.is_a?(Bitcoin::Key)
      pub_hex = [key.pub].pack('H*')
      return [key, pub_hex]
    rescue RuntimeError => e
      raise InvalidKeyError, 'Invalid key' if e.message == 'Invalid version'
    end

    def valid_sig?(i, public_script)
      tx.verify_input_signature(i, public_script)
    end

    def check
      raise ArgumentError, 'Please set "m" before signing'        unless m
      raise ArgumentError, 'Please set "pub_keys" before signing' unless pub_keys
    end
  end
end
