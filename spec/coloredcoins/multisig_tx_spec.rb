require 'bitcoin'

describe Coloredcoins::MultisigTx do
  let!(:tx_hex) do
    %w(
      010000000125b956a45ff3c6927ab85aaed92d88cdbea00a0d81
      341cfe535b982ab50cf9f70000000000ffffffff03ac02000000
      00000047512103ffffffffffffffffffffffffffffffffffffff
      ffffffffffffffffffffffffff2103caf376cb1cb7d09e33bf35
      5c4c7f5b7962502173627efbd1e3d2fc16573a65fb52ae000000
      00000000001c6a1a4343020287d1e95ca859b73cda02c81c772b
      a186dc1a12a00110e45c01000000000017a914e1088f81edc427
      ec81f128e2eac8e2f0e62465cd8700000000
    ).join
  end
  let!(:priv_keys) do
    %w(
      44159687da678ccc3374cd63a8be34727bb34a9a7ce02e1de0bb2c0a2c0a9ca8
      7ac707d5cf0198fd10b0aa267367c09feae8cf8cbe008b4b9840c67c3d0af4a1
      eb3ed894a8ea4f897884a65b9ef8d9f4d1704b9fe88f4133bb0c9d66d6420a7a
    )
  end
  let!(:wif)       { priv_keys[0] }
  let!(:pub_keys)  do
    %w(
      047a130127056525587eac13ad69f23c5e198d596025f65ac33d769e54fa3e3094b7aa4bad47aec9a0b1d487fd2b4f41eed468079de70f4526c721924ac3bfd121
      0442dbb77ea49ebe546982d2ad1cb0bea3ff3abfe8fb636858295622f8c5cbfd07b5a66e811e5178d8971a5f352299c163258aa6d81b56c980b679f1644b1dfd80
      0499df3d55d5741a2222d9a5d175e3bbd9124e61b4c7f5830356c0d8082861a0e3c61ee29ec2eaabd693f5f83568dfea0add98b1c3e971b9da7b01ed97ab3b74fb
    )
  end

  before do
    Bitcoin.network = :testnet
    Coloredcoins.network = Coloredcoins::TESTNET
  end

  subject do
    Coloredcoins::MultisigTx.build(tx_hex) do |tx|
      tx.m = 2
      tx.pub_keys = pub_keys
    end
  end

  describe '#sign' do
    let(:tx) { subject.tx }

    describe 'before sign' do
      it 'inputs should not be signed' do
        tx.inputs.each do |input|
          expect(input.script_sig).to be_empty
        end
      end

      it 'can be converted to hex' do
        expect { subject.to_hex }.not_to raise_error
      end

      it 'to_hex should be the same as the given hex' do
        expect(subject.to_hex).to eq(tx_hex)
      end
    end

    describe 'after sign' do
      let!(:key) do
        [
          Bitcoin::Key.new(priv_keys[0], pub_keys[0]),
          Bitcoin::Key.new(priv_keys[1], pub_keys[1])
        ]
      end
      before { subject.sign(key) }

      it 'inputs should be signed' do
        tx.inputs.each do |input|
          expect(input.script_sig).not_to be_empty
        end
      end

      it 'can be converted to hex' do
        expect { subject.to_hex }.not_to raise_error
      end
    end
  end

  describe '#broadcast' do
    let!(:tx_id) { 'some-transaction-hash' }
    let!(:broadcast_response) { { txId: tx_id } }

    before do
      allow(Coloredcoins).to receive(:broadcast).and_return(broadcast_response)
    end
    before { @response = subject.broadcast }

    it { expect(Coloredcoins).to have_received(:broadcast).once }

    it { expect(@response).to eq(tx_id) }
  end
end
