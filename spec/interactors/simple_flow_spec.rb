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

    context "error handling" do
      before do
        allow_any_instance_of(Interactor::Context).to receive(:account_token).and_return("1")
      end

      it "catch the error" do
        VCR.use_cassette('interactors/simpleflow_fail') do
          expect(interactor).not_to be_success
          expect(interactor.error_code).to be(:invalid_argument)
        end
      end
    end
  end
end
