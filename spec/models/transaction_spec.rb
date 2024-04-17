require 'spec_helper'

RSpec.describe 'Transaction' do
  after(:all) { Transaction.destroy_all}

  it "db validations" do
    transaction = Transaction.new attributes_for(:transaction)
    expect(transaction.save).to be true
  end
end
