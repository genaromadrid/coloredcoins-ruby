module Coloredcoins
  class MultisigTx < Transaction
    attr_accessor :m, :pub_keys, :key

    InvalidSignatureError = Class.new SecurityError

    def self.build(tx_hex)
      transaction = MultisigTx.new(tx_hex)
      yield transaction
      transaction
    end

    def sign
      check
      tx.inputs.each_with_index do |input, i|
        # signature_hash = tx.signature_hash_for_input(i, tx)
        sig = key.sign(redeem_script)
        public_script = Bitcoin::Script.to_signature_pubkey_script(sig, [key.pub].pack("H*"))
        tx.inputs[i].script_sig = public_script
        raise InvalidSignatureError, 'Invalid signature' unless tx.verify_input_signature(i, public_script)
      end
      true
    end

    def key=(key)
      @key = if key.is_a?(Bitcoin::Key)
          key
        else
          Bitcoin::Key.from_base58(key)
        end
    end

    def redeem_script
      @redeem_script ||= Bitcoin::Script.to_p2sh_multisig_script(m, *pub_keys).last
    end

    def address
      @address ||= Bitcoin.hash160_to_p2sh_address(Bitcoin.hash160(redeem_script.hth))
    end

    def broadcast
      Coloredcoins.broadcast(to_hex)
    end

    private

      def check
        fail ArgumentError, 'Please set "key" before signing'      unless key
        fail ArgumentError, 'Please set "m" before signing'        unless m
        fail ArgumentError, 'Please set "pub_keys" before signing' unless pub_keys
      end
  end
end
