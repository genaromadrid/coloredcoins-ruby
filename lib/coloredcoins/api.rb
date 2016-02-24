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
  end
end
