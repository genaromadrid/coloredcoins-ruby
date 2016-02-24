require 'bitcoin'
module Coloredcoins
  class API
    attr_reader :network,
                :api_version

    def initialize(network:'mainnet', api_version:'v3')
      @network = network
      @api_version = api_version
      @connection = Connection.new(url)
    end

    def url
      return "http://testnet.api.coloredcoins.org:80/#{api_version}" if testnet?
      "http://api.coloredcoins.org:80/#{api_version}"
    end

    def testnet?
      network == 'testnet'
    end

    def network=(network)
      @network = network
      @connection = Connection.new(url)
    end

    def issue_asset(asset)
      @connection.post('/issue', asset)
    end

    def send_asset(asset)
      @connection.post('/sendasset', asset)
    end

    def sign_tx(unsigned_tx, redeem_script, wif)
      Bitcoin.network = :bitcoin
      key = Bitcoin::Key.from_base58(wif)
      tx = build_tx(unsigned_tx)
      tx.inputs.each_with_index do |input, i|
        # signature_hash = tx.signature_hash_for_input(i, tx)
        signature = key.sign(redeem_script)
        tx.inputs[i].script_sig = signature
      end
      tx
    end

    def get_redeem_script(m, *pub_keys)
      address, redeem_script = Bitcoin.pubkeys_to_p2sh_multisig_address(m, *pub_keys)
      redeem_script
    end

    private

      def build_tx(hex)
        Bitcoin::P::Tx.new([hex].pack('H*'))
      end
  end
end
