require 'bitcoin'

describe Coloredcoins::MultisigTx do

  let!(:tx_hex)    { '0100000001719317d1d89cbbe89f0783053b5a6ba16ab584ac6f9a60ed25cafe94c6f9f3680000000000ffffffff020000000000000000096a074343010527b010ce8101000000000017a9141442dada3e43b037543440bad2ad9695a360a6558700000000' }
  let!(:priv_keys) {[
    'Kz6XuRHniKZfWxSLSC7YdN8AmB6oXaDSfHhxa6TPfwmcAC8URE7b',
    'L3u4otRKpgBwC8JaJPGiWpYWaLQqQngVVhmG6bZXoEL6V85bywnd',
    'KzaAL6uKn2zHUULhsESuDDNguS2TsjDZv3ebgiFbFzGSqg5oMZ89'
  ]}
  let!(:wif)       { priv_keys[1] }
  let!(:pub_keys)  {[
    '03ae3cf1075ab2c7544d973903c089295ab195af63a8f3c168c9b8901b457d9ce2',
    '0352f75a371a1331fa51a20b5e6e1e4ab8f86a1f65dd36fe44a9f7ce5d2a706946',
    '0330959f464f88f7294cc412a81f72f3cb817a2738a16e187d99b8e78c4ccf9e3b'
  ]}

  before do
    Bitcoin.network = :bitcoin
  end

  describe '#sign' do
    subject do
      Coloredcoins::MultisigTx.build(tx_hex) do |tx|
        tx.key = wif
        tx.m = 2
        tx.pub_keys = pub_keys
      end
    end
    let(:tx) { subject.tx }

    describe 'before sign' do
      it 'inputs should not be signed' do
        tx.inputs.each do |input|
          expect(input.script_sig).to be_empty
        end
      end
    end

    describe 'after sign' do
      before { subject.sign }

      it 'inputs should be signed' do
        tx.inputs.each do |input|
          expect(input.script_sig).not_to be_empty
        end
      end
    end

  end
end
