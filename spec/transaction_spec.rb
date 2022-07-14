require 'spec_helper'

RSpec.describe 'Transaction' do
  after(:all) { Transaction.destroy_all }

  it "db validations" do
    transaction = Transaction.new transaction_params
    expect(transaction.save).to be true
  end

  def transaction_params(attributes = {})
  	{
      intent_id: 'bbb170ae0ab9ad0d1447a59472b9b320',
      value_in_cents: 100000,
      status: 'PAID',
      paid_at: Time.parse("2022-02-20 18:41:11 -0500"),
      external_id: "0c7e9261-6b99-48aa-92f6-a1c878a37b90",
      currency: 'CFL'
  	}.merge(attributes)
  end
end
