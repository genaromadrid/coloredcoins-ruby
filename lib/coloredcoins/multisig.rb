# frozen_string_literal: true

# rubocop:disable Naming/UncommunicativeMethodParamName
module Coloredcoins
  class Multisig
    attr_reader :m, :pub_keys
    attr_writer :redeem_script

    def initialize(m = nil, pub_keys = nil)
      @m = m
      @pub_keys = pub_keys
    end

    def sign(tx, key)
      key = Coloredcoins::Transaction.build_key(key)
      tx.inputs.each_with_index do |input, i|
        sig_hash   = tx.signature_hash_for_input(i, redeem_script)
        sigs       = Coloredcoins::Transaction.build_sigs(key, sig_hash)
        initial    = input.script_sig.or(initial_script)

        input.script_sig = build_script_sig(sigs, sig_hash, initial)
      end
    end

    def valid_sig?(i, script)
      tx.verify_input_signature(i, script)
    end

    def address
      @address ||= Bitcoin.hash160_to_p2sh_address(Bitcoin.hash160(redeem_script.hth))
    end

    def redeem_script
      @redeem_script ||= Bitcoin::Script.to_p2sh_multisig_script(m, *pub_keys).last
    end

  private

    def initial_script
      @initial_script ||= Bitcoin::Script.to_p2sh_multisig_script_sig(redeem_script)
    end

    def build_script_sig(sigs, sig_hash, initial)
      # sort them first since they could not be sorted comming from a difirent library
      initial = Bitcoin::Script.sort_p2sh_multisig_signatures(initial, sig_hash)
      sigs.each do |sig|
        Bitcoin::Script.add_sig_to_multisig_script_sig(sig, initial)
      end
      Bitcoin::Script.sort_p2sh_multisig_signatures(initial, sig_hash)
    end
  end
end
# rubocop:enable Naming/UncommunicativeMethodParamName
