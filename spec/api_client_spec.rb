require 'spec_helper'

RSpec.describe ApiClient do
  let(:api_client) { described_class.new("jwt_token") }

  describe '#list_reports' do
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

      it 'returns JSON file when successful' do
        expect(HTTParty)
          .to receive(:get)
          .with('https://be-challenge-api.herokuapp.com/reports', headers: {'Authorization' => 'Bearer jwt_token'})
          .and_return(list_reports_response)

        expect {
          api_client.list_reports
        }.to raise_error(ApiClient::ApiClientError, /\'All other information on your level is restricted\'\(Forbidden\)/)
      end
    end
  end

  describe '#get_report' do
    let(:report) { reports.first }

    context 'when request is sucessful' do
      let(:get_report_response) { instance_double(HTTParty::Response, body: report.to_json, code: 200) }

      it 'returns JSON file when successful' do
        expect(HTTParty)
          .to receive(:get)
          .with("https://be-challenge-api.herokuapp.com/reports/#{report['report_id']}", headers: {'Authorization' => 'Bearer jwt_token'})
          .and_return(get_report_response)

        result = api_client.get_report(report['report_id'])
        expect(result).to eq(report.to_json)
      end
    end

    context 'when report id does not exist' do
      let(:get_report_response) { instance_double(HTTParty::Response, code: 404, body: "'Who is this? Whats your operating number?' (Not Found)") }

      it 'returns JSON file when successful' do
        expect(HTTParty)
          .to receive(:get)
          .with("https://be-challenge-api.herokuapp.com/reports/#{report['report_id']}", headers: {'Authorization' => 'Bearer jwt_token'})
          .and_return(get_report_response)

        expect {
          api_client.get_report(report['report_id'])
        }.to raise_error(ApiClient::ApiClientError, /\'Who is this\? Whats your operating number\?\' \(Not Found\)/)
      end
    end

    context 'when authentication fails' do
      let(:get_report_response) { instance_double(HTTParty::Response, code: 403, body: "'All other information on your level is restricted'(Forbidden)") }

      it 'returns JSON file when successful' do
        expect(HTTParty)
          .to receive(:get)
          .with("https://be-challenge-api.herokuapp.com/reports/#{report['report_id']}", headers: {'Authorization' => 'Bearer jwt_token'})
          .and_return(get_report_response)

        expect {
          api_client.get_report(report['report_id'])
        }.to raise_error(ApiClient::ApiClientError, /\'All other information on your level is restricted\'\(Forbidden\)/)
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
end
