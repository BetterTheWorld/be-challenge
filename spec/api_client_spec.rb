require 'spec_helper'

RSpec.describe ApiClient do
  let(:api_client) { described_class.new }

  describe '#list_reports' do
    before do
      expect(HTTParty)
          .to receive(:post)
          .with('https://be-challenge-api.herokuapp.com/login', body: { "email"=>"eduardo@gmail.com", "password"=>"Password1" })
          .and_return({ 'token' => 'jwt_token'  })
    end

    context 'when request is sucessful' do
      let(:list_reports_response) { instance_double(HTTParty::Response, body: reports.to_json, code: 200) }

      it 'returns JSON file when successful' do
        expect(HTTParty)
          .to receive(:get)
          .with('https://be-challenge-api.herokuapp.com/reports', headers: {'Authorization' => 'Bearer jwt_token'})
          .and_return(list_reports_response)

        result = api_client.list_reports
        expect(result).to eq(reports)
      end
    end

    context 'when authentication fails' do
      let(:list_reports_response) { instance_double(HTTParty::Response, code: 403, body: "'All other information on your level is restricted'(Forbidden)") }

      it 'raises unathorized error' do
        expect(HTTParty)
          .to receive(:get)
          .with('https://be-challenge-api.herokuapp.com/reports', headers: {'Authorization' => 'Bearer jwt_token'})
          .and_return(list_reports_response)

        expect {
          api_client.list_reports
        }.to raise_error(ApiClient::Unauthorized, /\'All other information on your level is restricted\'\(Forbidden\)/)
      end
    end

    context 'when returns unexpected error' do
      let(:list_reports_response) { instance_double(HTTParty::Response, code: 500, body: "Unexpected error") }

      it 'raises unexpected error' do
        expect(HTTParty)
          .to receive(:get)
          .with('https://be-challenge-api.herokuapp.com/reports', headers: {'Authorization' => 'Bearer jwt_token'})
          .and_return(list_reports_response)

        expect {
          api_client.list_reports
        }.to raise_error(ApiClient::UnexpectedError, /Unexpected error/)
      end
    end
  end

  describe '#get_report' do
    let(:report_id) { 7426 }

    before do
      expect(HTTParty)
          .to receive(:post)
          .with('https://be-challenge-api.herokuapp.com/login', body: { "email"=>"eduardo@gmail.com", "password"=>"Password1" })
          .and_return({ 'token' => 'jwt_token'  })
    end

    context 'when request is sucessful' do
      let(:get_report_response) { instance_double(HTTParty::Response, body: report_details.to_json, code: 200) }

      it 'returns JSON file when successful' do
        expect(HTTParty)
          .to receive(:get)
          .with("https://be-challenge-api.herokuapp.com/reports/#{report_id}", headers: {'Authorization' => 'Bearer jwt_token'})
          .and_return(get_report_response)

        result = api_client.get_report(report_id)
        expect(result).to eq(report_details.to_json)
      end
    end

    context 'when report id does not exist' do
      let(:get_report_response) { instance_double(HTTParty::Response, code: 404, body: "'Who is this? Whats your operating number?' (Not Found)") }

      it 'raises not found error' do
        expect(HTTParty)
          .to receive(:get)
          .with("https://be-challenge-api.herokuapp.com/reports/#{report_id}", headers: {'Authorization' => 'Bearer jwt_token'})
          .and_return(get_report_response)

        expect {
          api_client.get_report(report_id)
        }.to raise_error(ApiClient::NotFoundError, /\'Who is this\? Whats your operating number\?\' \(Not Found\)/)
      end
    end

    context 'when authentication fails' do
      let(:get_report_response) { instance_double(HTTParty::Response, code: 403, body: "'All other information on your level is restricted'(Forbidden)") }

      it 'raises unauthorized error' do
        expect(HTTParty)
          .to receive(:get)
          .with("https://be-challenge-api.herokuapp.com/reports/#{report_id}", headers: {'Authorization' => 'Bearer jwt_token'})
          .and_return(get_report_response)

        expect {
          api_client.get_report(report_id)
        }.to raise_error(ApiClient::Unauthorized, /\'All other information on your level is restricted\'\(Forbidden\)/)
      end
    end

    context 'when returns unexpected error' do
      let(:get_report_response) { instance_double(HTTParty::Response, code: 500, body: "Unexpected Error") }

      it 'raises unexpected error' do
        expect(HTTParty)
          .to receive(:get)
          .with("https://be-challenge-api.herokuapp.com/reports/#{report_id}", headers: {'Authorization' => 'Bearer jwt_token'})
          .and_return(get_report_response)

        expect {
          api_client.get_report(report_id)
        }.to raise_error(ApiClient::UnexpectedError, /Unexpected Error/)
      end
    end
  end

  private

  def reports
    [
      {
        "name"=>"Kamino Human Resources, LTD",
        "location"=>"Kamino",
        "currency"=>"Republic Credits",
        "symbol"=>"RCR",
        "report_id"=>7426,
        "format"=>"json",
        "referrence_id"=>"The id you submited to identify your transaction is under 'account', as 'referrence_id'"
      }
    ]
  end

  def report_details
    [
      {
        "id": "a3715bed-5d49-475d-91e9-962c31b374e2",
        "created_at": "2022-02-20 18:54:46 -0500",
        "placed_at": "2022-02-20 19:09:31 -0500",
        "paid_at": "2022-02-20 19:09:31 -0500",
        "value": 7450495,
        "status": "paid",
        "items": [
            {
                "sku": 101,
                "name": "Standard Clones",
                "units": 11000
            },
            {
                "sku": 666,
                "name": "Elite Clone",
                "units": 500
            }
        ],
        "delivery_notes": "No delivery scheduled",
        "account": {
            "id": 3076,
            "email": "3076@galacticsenate.com",
            "referrence_id": "986f81216a9e7a9d16cace11e8fecc15"
        }
      }
    ]
  end
end
