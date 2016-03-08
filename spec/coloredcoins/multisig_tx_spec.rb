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
  let!(:pre_signed_tx_hex) do
    %w(
      010000000125b956a45ff3c6927ab85aaed92d88cdbea00a0d813
      41cfe535b982ab50cf9f700000000fd150100483045022100d57f
      6d91ce7475d0e47e8ec76f486d1c6a24a04caad93b484b7d0dc3d7
      d90ac802201e1793473e2c1b88695fe50b99ec8a92b88a947f21cb
      d073cdf7aa03ffbf269b014cc95241047a130127056525587eac13
      ad69f23c5e198d596025f65ac33d769e54fa3e3094b7aa4bad47ae
      c9a0b1d487fd2b4f41eed468079de70f4526c721924ac3bfd12141
      0442dbb77ea49ebe546982d2ad1cb0bea3ff3abfe8fb6368582956
      22f8c5cbfd07b5a66e811e5178d8971a5f352299c163258aa6d81b
      56c980b679f1644b1dfd80410499df3d55d5741a2222d9a5d175e3
      bbd9124e61b4c7f5830356c0d8082861a0e3c61ee29ec2eaabd693
      f5f83568dfea0add98b1c3e971b9da7b01ed97ab3b74fb53aeffff
      ffff03ac0200000000000047512103ffffffffffffffffffffffff
      ffffffffffffffffffffffffffffffffffffffff2103caf376cb1c
      b7d09e33bf355c4c7f5b7962502173627efbd1e3d2fc16573a65fb
      52ae00000000000000001c6a1a4343020287d1e95ca859b73cda02
      c81c772ba186dc1a12a00110e45c01000000000017a914e1088f81
      edc427ec81f128e2eac8e2f0e62465cd8700000000
    ).join
  end
  let!(:prev_tx_hex) do
    %w(
      0100000001463e1b35f72a4e978f2b7fb82f95823e90e4f50b30
      a1372f92fee0694fc92159020000006a47304402202f5b00e3fc
      0879488196c394283245f8f6d4b310b61fd14cc4bc38dbb2fb7e
      6e02202bc37e902b4cafc58defc87bd009ca4d6aa2ef1ab12219
      2062d87ed43cf5a9860121020b4dfdc746ea23b6815b108227bc
      be5aa86f3611275f56bb06476f7d256c2d6cffffffff03a08601
      000000000017a914e1088f81edc427ec81f128e2eac8e2f0e624
      65cd8710270000000000001976a914c854b52234e57ac254ae35
      ef6b3dd7ead98ce14288ac9cc71200000000001976a914eed95b
      73ccde2019ef1da4c6e9b4062c5cda881988ac00000000
    ).join
  end
  let!(:prev_tx) { Bitcoin::P::Tx.new([prev_tx_hex].pack('H*')) }
  let!(:priv_keys) do
    %w(
      44159687da678ccc3374cd63a8be34727bb34a9a7ce02e1de0bb2c0a2c0a9ca8
      7ac707d5cf0198fd10b0aa267367c09feae8cf8cbe008b4b9840c67c3d0af4a1
      eb3ed894a8ea4f897884a65b9ef8d9f4d1704b9fe88f4133bb0c9d66d6420a7a
    )
  end
  # rubocop:disable Metrics/LineLength
  let!(:pub_keys) do
    %w(
      047a130127056525587eac13ad69f23c5e198d596025f65ac33d769e54fa3e3094b7aa4bad47aec9a0b1d487fd2b4f41eed468079de70f4526c721924ac3bfd121
      0442dbb77ea49ebe546982d2ad1cb0bea3ff3abfe8fb636858295622f8c5cbfd07b5a66e811e5178d8971a5f352299c163258aa6d81b56c980b679f1644b1dfd80
      0499df3d55d5741a2222d9a5d175e3bbd9124e61b4c7f5830356c0d8082861a0e3c61ee29ec2eaabd693f5f83568dfea0add98b1c3e971b9da7b01ed97ab3b74fb
    )
  end
  # rubocop:enable Metrics/LineLength
  let!(:m)             { 2 }
  let!(:redeem_script) { Bitcoin::Script.to_p2sh_multisig_script(m, *pub_keys).last }
  let!(:wif)           { priv_keys[0] }
  let!(:keys) do
    priv_keys.map.with_index do |priv_key, i|
      Bitcoin::Key.new(priv_key, pub_keys[i])
    end
  end

  before do
    Bitcoin.network = :testnet3
    Coloredcoins.network = Coloredcoins::TESTNET
  end

  subject do
    Coloredcoins::MultisigTx.build(tx_hex) do |tx|
      tx.m = m
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
      shared_examples 'after_sign_transaction' do
        it 'inputs should be signed' do
          tx.inputs.each do |input|
            expect(input.script_sig).not_to be_empty
          end
        end

        it 'can be converted to hex' do
          expect { subject.to_hex }.not_to raise_error
        end
      end

      context 'with one key' do
        let!(:key) { keys[0] }
        before { subject.sign(key) }
        it_behaves_like 'after_sign_transaction'

        describe 'signatures' do
          it 'should not be valid yet' do
            tx.inputs.each_with_index do |_input, i|
              expect(tx.verify_input_signature(i, prev_tx)).to be false
            end
          end

          it 'can be converted to hex' do
            expect { subject.to_hex }.not_to raise_error
          end

          context 'with another key' do
            let!(:partially_signed_tx) do
              Coloredcoins::MultisigTx.build(subject.to_hex) do |tx|
                tx.m = m
                tx.pub_keys = pub_keys
              end
            end
            let(:partial_tx) { partially_signed_tx.tx }

            it { expect(partially_signed_tx.to_hex) }

            context 'when signed' do
              before { partially_signed_tx.sign(keys[1]) }

              it 'should be valid' do
                partial_tx.inputs.each_with_index do |_input, i|
                  expect(partial_tx.verify_input_signature(i, prev_tx)).to be true
                end
              end

              it 'can be converted to hex' do
                expect { partially_signed_tx.to_hex }.not_to raise_error
              end
            end
          end
        end
      end

      context 'with a pre-signed signed tx' do
        let!(:partially_signed_tx) do
          Coloredcoins::MultisigTx.build(pre_signed_tx_hex) do |tx|
            tx.m = m
            tx.pub_keys = pub_keys
          end
        end
        let(:tx) { partially_signed_tx.tx }

        before { partially_signed_tx.sign(keys[1]) }

        it 'should be valid' do
          tx.inputs.each_with_index do |_input, i|
            expect(tx.verify_input_signature(i, prev_tx)).to be true
          end
        end

        it 'can be converted to hex' do
          expect { partially_signed_tx.to_hex }.not_to raise_error
        end
      end

      context 'with several keys' do
        let!(:key) { [keys[0], keys[1]] }
        before { subject.sign(key) }
        it_behaves_like 'after_sign_transaction'

        describe 'signatures' do
          it 'should be valid' do
            tx.inputs.each_with_index do |_input, i|
              expect(tx.verify_input_signature(i, prev_tx)).to be true
            end
          end

          it 'can be converted to hex' do
            expect { subject.to_hex }.not_to raise_error
          end
        end
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
