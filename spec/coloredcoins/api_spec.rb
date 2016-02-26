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
end
