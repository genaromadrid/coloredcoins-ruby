describe Coloredcoins do
  describe '#issue_asset' do
    it 'should call the API' do
      allow(Coloredcoins.api).to receive(:issue_asset)
      Coloredcoins.issue_asset({})
      expect(Coloredcoins.api).to have_received(:issue_asset)
    end
  end

  describe '#send_asset' do
    it 'should call the API' do
      allow(Coloredcoins.api).to receive(:send_asset)
      Coloredcoins.send_asset({})
      expect(Coloredcoins.api).to have_received(:send_asset)
    end
  end

  describe '#broadcast' do
    it 'should call the API' do
      allow(Coloredcoins.api).to receive(:broadcast)
      Coloredcoins.broadcast('tx_hex')
      expect(Coloredcoins.api).to have_received(:broadcast)
    end
  end

  describe '#address_info' do
    it 'should call the API' do
      allow(Coloredcoins.api).to receive(:address_info)
      Coloredcoins.address_info('address')
      expect(Coloredcoins.api).to have_received(:address_info)
    end
  end

  describe '#asset_holders' do
    it 'should call the API' do
      allow(Coloredcoins.api).to receive(:asset_holders)
      Coloredcoins.asset_holders('asset_id')
      expect(Coloredcoins.api).to have_received(:asset_holders)
    end
  end

  describe '#asset_metadata' do
    it 'should call the API' do
      allow(Coloredcoins.api).to receive(:asset_metadata)
      Coloredcoins.asset_metadata('asset_id', 'utxo')
      expect(Coloredcoins.api).to have_received(:asset_metadata)
    end
  end

  describe '#some_undifined_method' do
    it 'should not call the API' do
      expect { Coloredcoins.some_undifined_method }.to raise_error(NoMethodError)
    end
  end
end
