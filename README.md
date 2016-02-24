# Coloredcoins

Ruby wrapper for coloredcoins.org

## Installation

Add this line to your application's Gemfile:

    gem 'coloredcoins'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install coloredcoins

## Usage

You can use any of these methods with the initialized object or simply by calling:

### Issue Asset

```ruby
address = 'n4SKTwh8xxNMSH7uN2xRZym7iXCZNwy8vj'
asset = {
  'issueAddress': address,
  'amount': 100,
  'divisibility': 0,
  'fee': 1000,
  'reissueable':false,
  'transfer': [{
    'address': address,
    'amount': 100
  }],
  'metadata': {
    'assetId': '1',
    'assetName': 'Asset Name',
    'issuer': 'Asset Issuer',
    'description': 'My Description',
    'urls': [
      {
        name:'icon', 
        url: 'https://pbs.twimg.com/profile_images/572390580823412736/uzfQSciL_bigger.png', 
        mimeType: 'image/png', 
        dataHash: ''
      }
    ],
    'userData': {
      'meta' : [
        { key: 'Item ID', value: 2, type: 'Number' },
        { key: 'Item Name', value: 'Item Name', type: 'String' },
        { key: 'Company', value: 'My Company', type: 'String' },
        { key: 'Address', value: 'San Francisco, CA', type: 'String' }
      ]
    }
  }
}
response = Coloredcoins.issue_asset(asset)
# response[:txHex]
# response[:assetId]
```

## Contributing

1. Fork it ( https://github.com/[my-github-username]/coloredcoins/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
