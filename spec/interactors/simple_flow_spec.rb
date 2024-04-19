require 'rspec'
require 'httparty'
require 'vcr'
require 'spec_helper'

# rspec --format documentation

RSpec.describe SimpleFlow do
  let(:organization_name) { 'Shopify' }
  let(:email) { 'commerce4@shopify.com' }
  let(:password) { 'Taco1234' }
  let(:params) do
    {
      name: organization_name,
      email: email,
      password: password
    }
  end
  let(:interactor) { described_class.call(params: params) }

  describe '#call' do
    it 'creates only the transactions' do
      VCR.use_cassette('interactors/simpleflow') do
        expect(interactor.success?).to be true

        expect(Transaction.count).to eq(70)
        expect(Report.count).to eq(0)
        expect(Organization.count).to eq(0)
      end
    end
  end
end
