# Coloredcoins

[![Build Status][travis-image]][travis-url]
[![Coverage Status][coverage-image]][coverage-url]

Ruby wrapper for coloredcoins.org

## Installation

Add this line to your application's Gemfile:

    gem 'coloredcoins'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install coloredcoins

## Usage

Initialize the API

```
network = Coloredcoins::TESTNET
api_version = 'v3' # defaults to 'v3'
api = Coloredcoins::API.new(network, api_version)
```

> You can use any method with the initialized object or simply by calling the method from the `Coloredcoins` module.

The default network is *MAINNET*, use the following to change to *TESTNET*.

```ruby
Coloredcoins.network = Coloredcoins::TESTNET
```

### Issue Asset

http://coloredcoins.org/documentation/#IssueAsset

```ruby
asset = { ... }

response = Coloredcoins.issue_asset(asset)
response[:txHex] # => 0100000001ee58da20e...8ac00000000
response[:assetId] # => LYfzkq2KP6K5rhNR7mE9B6BmhiHTtxvMxY
```

### Send asset

http://coloredcoins.org/documentation/#SendAsset

```ruby
asset = { ... }

response = Coloredcoins.send_asset(asset)
response[:txHex] # => 0100000001ee58da20e...8ac00000000
```

### Broadcast Multiig Transaction

http://coloredcoins.org/documentation/#BroadcastTransaction

```ruby
publ_keys = [
  '03ae3cf1075ab2c7544d973903c089295ab195af63a8f3c168c9b8901b457d9ce2',
  '0352f75a371a1331fa51a20b5e6e1e4ab8f86a1f65dd36fe44a9f7ce5d2a706946',
  '0330959f464f88f7294cc412a81f72f3cb817a2738a16e187d99b8e78c4ccf9e3b'
]
wif = 'Kz6XuRHniKZfWxSLSC7YdN8AmB6oXaDSfHhxa6TPfwmcAC8URE7b'
transaction = Coloredcoins::MultisigTx.build(tx_hex) do |tx|
  tx.m = 2 # 'm' x n Multisig
  tx.pub_keys = pub_keys
end
transaction.sign(wif)
# Broadcast returns the broadcasted transaction id
transaction.broadcast # => '98a1ebf2b80eafe4cc58bb01e1eb74a09038e60a67032cacdb3dfb8bf83175de'
```

### Get Address Info

http://coloredcoins.org/documentation/#GetAddressInfo

```ruby
Coloredcoins.address_info('n4SKTwh8xxNMSH7uN2xRZym7iXCZNwy8vj')
```

### Get Asset Holders

http://coloredcoins.org/documentation/#GetAssetHolders

```ruby
asset_id = 'LYfzkq2KP6K5rhNR7mE9B6BmhiHTtxvMxY'
num_confirmations = 2 # defaults to 1

response = Coloredcoins.asset_holders(asset_id, num_confirmations)
response[:holders] # [{ address: 'LYfzkq2KP6K5rhNR7mE9B6BmhiHTtxvMxY', amount: 100 }]
response[:divisibility] # 0
response[:lockStatus] # nil
```

### Get Asset Metadata

http://coloredcoins.org/documentation/#GetAssetMetadata

```ruby
asset_id = 'LYfzkq2KP6K5rhNR7mE9B6BmhiHTtxvMxY'
tx_id = '98a1ebf2b80eafe4cc58bb01e1eb74a09038e60a67032cacdb3dfb8bf83175de'
utxo = tx_id+':1'

Coloredcoins.asset_metadata(asset_id, utxo)
```

## Contributing

1. Fork it ( https://github.com/[my-github-username]/coloredcoins/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

[travis-image]: https://travis-ci.org/genaromadrid/coloredcoins-ruby.svg?branch=master
[travis-url]: https://travis-ci.org/genaromadrid/coloredcoins-ruby
[coverage-image]: https://coveralls.io/repos/github/genaromadrid/coloredcoins-ruby/badge.svg?branch=master
[coverage-url]: https://coveralls.io/github/genaromadrid/coloredcoins-ruby?branch=master
