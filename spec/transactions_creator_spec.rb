require 'spec_helper'

RSpec.describe TransactionsCreator do
  describe '#create!' do
    let(:creator) { described_class.new(transactions_attributes) }

    after do
      Transaction.destroy_all
    end

    context 'when all transactions are paid' do
      let(:transactions_attributes) do
        [
          {
            currency: 'RCR',
            external_id: 'a3715bed-5d49-475d-91e9-962c31b374e2',
            intent_id:'986f81216a9e7a9d16cace11e8fecc15',
            paid_at: Time.parse('2022-02-20 19:09:31.000000000 -0500'),
            status: 'PAID',
            value_in_cents: 745049500
          },
          {
            currency: 'RCR',
            external_id: 'fad6e5eb-c092-4352-b063-288a082021da',
            intent_id:'f3b4c654acfe54375e7786d34664120f',
            paid_at: Time.parse('2022-02-20 19:09:31.000000000 -0500'),
            status: 'PAID',
            value_in_cents: 349437900
          }
        ]
      end

      it 'creates all the transactions properly' do
        expect { creator.create! }.to change(Transaction, :count).by(2)

        transaction = Transaction.find_by(external_id: 'a3715bed-5d49-475d-91e9-962c31b374e2')
        expect(transaction.currency).to eq('RCR')
        expect(transaction.external_id).to eq('a3715bed-5d49-475d-91e9-962c31b374e2')
        expect(transaction.intent_id).to eq('986f81216a9e7a9d16cace11e8fecc15')
        expect(transaction.paid_at).to eq(Time.parse('2022-02-20 19:09:31.000000000 -0500'))
        expect(transaction.status).to eq('PAID')
        expect(transaction.value_in_cents).to eq(745049500)

        transaction = Transaction.find_by(external_id: 'fad6e5eb-c092-4352-b063-288a082021da')
        expect(transaction.currency).to eq('RCR')
        expect(transaction.external_id).to eq('fad6e5eb-c092-4352-b063-288a082021da')
        expect(transaction.intent_id).to eq('f3b4c654acfe54375e7786d34664120f')
        expect(transaction.paid_at).to eq(Time.parse('2022-02-20 19:09:31.000000000 -0500'))
        expect(transaction.status).to eq('PAID')
        expect(transaction.value_in_cents).to eq(349437900)
      end
    end

    context 'when a transaction is partially refunded' do
      let(:transactions_attributes) do
        [
          {
            currency: 'RCR',
            external_id: 'a3715bed-5d49-475d-91e9-962c31b374e2',
            intent_id:'986f81216a9e7a9d16cace11e8fecc15',
            paid_at: Time.parse('2022-02-20 19:09:31.000000000 -0500'),
            status: 'PAID',
            value_in_cents: 745049500
          },
          {
            currency: 'RCR',
            external_id: 'a3715bed-5d49-475d-91e9-962c31b374e2',
            intent_id:'986f81216a9e7a9d16cace11e8fecc15',
            paid_at: Time.parse('2022-02-20 19:09:31.000000000 -0500'),
            status: 'PARTIALLY_REFUNDED',
            value_in_cents: 438645100
          }
        ]
      end

      it 'updates the transaction properly' do
        expect { creator.create! }.to change(Transaction, :count).by(1)

        transaction = Transaction.find_by(external_id: 'a3715bed-5d49-475d-91e9-962c31b374e2')
        expect(transaction.currency).to eq('RCR')
        expect(transaction.external_id).to eq('a3715bed-5d49-475d-91e9-962c31b374e2')
        expect(transaction.intent_id).to eq('986f81216a9e7a9d16cace11e8fecc15')
        expect(transaction.paid_at).to eq(Time.parse('2022-02-20 19:09:31.000000000 -0500'))
        expect(transaction.status).to eq('PARTIALLY_REFUNDED')
        expect(transaction.value_in_cents).to eq(438645100)
      end
    end
  end
end
