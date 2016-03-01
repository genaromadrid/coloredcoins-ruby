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
      multisig = Coloredcoins::Multisig.new(m, *pub_keys)
      multisig.sign(tx, key)
      true
    end

  private

    def check
      raise ArgumentError, 'Set "m" before signing' unless m
      if !pub_keys && !redeem_script
        raise ArgumentError, 'Set "pub_keys" or "redeem_script" before signing'
      end
    end
  end
end

class String
  def or(what)
    strip.empty? ? what : self
  end
end
