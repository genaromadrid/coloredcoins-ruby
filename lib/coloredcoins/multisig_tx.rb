module Coloredcoins
  class MultisigTx < Transaction
    attr_accessor :m, :pub_keys, :redeem_script

    def self.build(tx_hex)
      transaction = MultisigTx.new(tx_hex)
      yield transaction
      transaction
    end

    def sign(key)
      check
      key = build_key(key) unless key.is_a?(Array)
      tx.inputs.each_with_index do |input, i|
        sig_hash    = tx.signature_hash_for_input(i, redeem_script)
        sigs        = sign_hash(key, sig_hash)
        script_sig  = build_script_sig(sigs, sig_hash)

        input.script_sig = script_sig
        raise Coloredcoins::InvalidSignatureError unless valid_sig?(i, script_sig)
      end
      true
    end

    def redeem_script
      @redeem_script ||= Bitcoin::Script.to_p2sh_multisig_script(m, *pub_keys).last
    end

    def address
      @address ||= Bitcoin.hash160_to_p2sh_address(Bitcoin.hash160(redeem_script.hth))
    end

  private

    def sign_hash(key, sig_hash)
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

    def build_script_sig(sigs, sig_hash)
      script_sig = Bitcoin::Script.to_p2sh_multisig_script_sig(redeem_script)
      sigs.each do |sig|
        script_sig = Bitcoin::Script.add_sig_to_multisig_script_sig(sig, script_sig)
      end
      Bitcoin::Script.sort_p2sh_multisig_signatures(script_sig, sig_hash)
    end

    def build_key(key)
      key = Bitcoin::Key.from_base58(key) unless key.is_a?(Bitcoin::Key)
      key
    rescue RuntimeError => e
      raise InvalidKeyError, 'Invalid key' if e.message == 'Invalid version'
    end

    def valid_sig?(i, script)
      tx.verify_input_signature(i, script)
    end

    def check
      raise ArgumentError, 'Set "m" before signing' unless m
      if !pub_keys && !redeem_script
        raise ArgumentError, 'Set "pub_keys" or "redeem_script" before signing'
      end
    end
  end
end
