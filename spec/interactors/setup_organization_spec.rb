require 'rspec'
require 'httparty'
require 'vcr'
require 'spec_helper'

# rspec --format documentation

RSpec.describe SetupOrganization do
  let(:organization_name) { 'Shopify' }
  let(:email) { "commerce@shopify.com" }
  let(:password) { "Taco1234" }
  let(:params) do
    {
      name: organization_name,
      email: email,
      password: password
    }
  end
  let(:interactor){ described_class.call(params: params)}

  describe "#call" do
    it "creates the transactions" do
      VCR.use_cassette('interactors/setup_organization') do
        expect(interactor.success?).to be true
        expect(Transaction.count).to eq(70)
      end
    end
  end
end
