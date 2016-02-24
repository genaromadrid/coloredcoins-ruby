module Coloredcoins
  class API
    attr_reader :network,
                :api_version

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

    def issue_asset(asset)
      @connection.post('/issue', asset)
    end

    def send_asset(asset)
      @connection.post('/sendasset', asset)
    end

    def broadcast(tx_hex)
      @connection.post('/broadcast', txHex: tx_hex)
    end
  end
end
