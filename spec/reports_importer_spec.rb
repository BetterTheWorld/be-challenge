require 'spec_helper'

RSpec.describe ReportsImporter do
  let(:importer) { described_class.new }

  describe '#import!' do
    context 'when requests are sucessful' do
      let(:report_id) { reports.first['report_id'] }

      it 'import transactions in the database' do
        expect_any_instance_of(ApiClient)
          .to receive(:list_reports)
          .and_return(reports)

        expect_any_instance_of(ApiClient)
          .to receive(:get_report)
          .with(report_id)
          .and_return(report_details.to_json)

        expect {
          importer.import!
        }.to change(Transaction, :count).by(1)
      end
    end

    context 'when api client returns error' do
      it 'returns JSON file when successful' do
        expect_any_instance_of(ApiClient)
          .to receive(:list_reports)
          .and_raise(ApiClient::UnexpectedError.new('Unexpected error'))

        expect {
          importer.import!
        }.to raise_error(ApiClient::UnexpectedError, /Unexpected error/)
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
