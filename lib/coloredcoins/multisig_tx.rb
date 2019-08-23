# frozen_string_literal: true

module Coloredcoins
  class MultisigTx < Transaction
    attr_accessor :m,
                  :pub_keys
    attr_writer :multisig

    def self.build(tx_hex)
      transaction = MultisigTx.new(tx_hex)
      yield transaction
      transaction
    end

    def sign(key)
      check
      multisig.sign(tx, key)
      true
    end

    def multisig
      @multisig ||= Coloredcoins::Multisig.new(m, pub_keys)
    end

    def redeem_script
      multisig.redeem_script
    end

    def redeem_script=(script)
      multisig.redeem_script = script
    end

  private

    def check
      raise ArgumentError, 'Set "m" before signing' unless multisig.m
      return true if multisig.pub_keys || multisig.redeem_script

      raise ArgumentError, 'Set "pub_keys" or "redeem_script" before signing'
    end
  end
end

class String
  def or(what)
    strip.empty? ? what : self
  end
end
