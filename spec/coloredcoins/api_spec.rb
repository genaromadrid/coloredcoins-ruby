describe Coloredcoins::API do
  describe 'changing network' do
    Coloredcoins::NETS.each do |network|
      describe "in #{network}" do
        context 'when Coloredcoins.network changes' do
          before { Coloredcoins.network = network }

          it { expect(Coloredcoins.api.network).to eq(network) }

          context 'when instanciating the API' do
            subject { Coloredcoins::API.new }

            it { expect(subject.network).to eq(network) }
          end
        end

        context 'when changing the nexwork on an instance' do
          subject { Coloredcoins::API.new }
          before { subject.network = network }

          it 'should change the url in its connection' do
            url = network == Coloredcoins::TESTNET ? '//testnet' : '//api'
            expect(subject.connection.url).to include(url)
          end
        end
      end
    end
  end

  describe 'conncetion methods' do
    before do
      allow(subject.connection).to receive(:post)
      allow(subject.connection).to receive(:get)
    end

    describe '#issue_asset' do
      it 'should call connection' do
        subject.issue_asset({})
        expect(subject.connection).to have_received(:post).with(/issue/, {})
      end
    end

    describe '#send_asset' do
      it 'should call connection' do
        subject.send_asset({})
        expect(subject.connection).to have_received(:post).with(/sendasset/, {})
      end
    end

    describe '#broadcast' do
      it 'should call connection' do
        subject.broadcast('hex')
        expect(subject.connection).to have_received(:post).with(/broadcast/, txHex: 'hex')
      end
    end

    describe '#address_info' do
      it 'should call connection' do
        subject.address_info('2NDm6HFAeyQYUfMXyFnd9yz5JBSkkWsj7Vz')
        expect(subject.connection).to have_received(:get).with(/addressinfo/)
      end
    end

    describe '#asset_holders' do
      it 'should call connection' do
        subject.asset_holders('asset_id', 1)
        expect(subject.connection).to have_received(:get).with(/stakeholders/)
      end
    end

    describe '#asset_metadata' do
      it 'should call connection' do
        subject.asset_metadata('asset_id', 'utxo:1')
        expect(subject.connection).to have_received(:get).with(/assetmetadata/)
      end
    end
  end
end
