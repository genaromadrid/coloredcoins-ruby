module Coloredcoins
  class API
    attr_reader :network,
                :api_version,
                :connection

    def initialize(network:Coloredcoins.network, api_version:'v3')
      @network = network
      @api_version = api_version
      @connection = Connection.new(url)
    end

    def url
      return "http://testnet.api.coloredcoins.org:80/#{api_version}" if testnet?
      "http://api.coloredcoins.org:80/#{api_version}"
    end

    def testnet?
      network == Coloredcoins::TESTNET
    end

    def network=(network)
      @network = network
      @connection = Connection.new(url)
    end

    # http://coloredcoins.org/documentation/#IssueAsset
    def issue_asset(asset)
      @connection.post('/issue', asset)
    end

    # http://coloredcoins.org/documentation/#SendAsset
    def send_asset(asset)
      @connection.post('/sendasset', asset)
    end

    # http://coloredcoins.org/documentation/#BroadcastTransaction
    def broadcast(tx_hex)
      @connection.post('/broadcast', txHex: tx_hex)
    end

    # http://coloredcoins.org/documentation/#GetAddressInfo
    def address_info(address)
      @connection.get("/addressinfo/#{address}")
    end

    # http://coloredcoins.org/documentation/#GetAssetHolders
    def asset_holders(asset_id, num_confirmations = 1)
      @connection.get("/stakeholders/#{asset_id}/#{num_confirmations}")
    end

    # http://coloredcoins.org/documentation/#GetAssetMetadata
    def asset_metadata(asset_id, utxo)
      @connection.get("/assetmetadata/#{asset_id}/#{utxo}")
    end
  end
end
