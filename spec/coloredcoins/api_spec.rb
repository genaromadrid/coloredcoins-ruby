describe Coloredcoins::API do
  describe '#network' do
    Coloredcoins::NETS.each do |network|
      context "when Coloredcoins.network is '#{network}'" do
        before { Coloredcoins.network = network }

        it { expect(Coloredcoins.api.network).to eq(network) }

        context 'when instanciating the API' do
          subject { Coloredcoins::API.new }

          it { expect(subject.network).to eq(network) }
        end
      end
    end
  end
end
