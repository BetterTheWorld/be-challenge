require 'spec_helper'

RSpec.describe CsvReportDetailsParser do
  describe '#parse' do
    let(:parser) { described_class.new(report, report_details) }
    let(:report) do
      {
        'id' => 7654,
        'format' => 'csv',
        'symbol' => 'RCR'
      }
    end

    let(:report_details) do
      "id,created_at,placed_at,paid_at,value,status,order_details,account_number,account_external_ref,account_name,account_contact\n" +
      "3c8afb55-002f-4ed5-ae3f-7af240405662,2022-02-21 04:51:01 -0500,2022-02-21 06:24:48 -0500,2022-02-21 06:24:48 -0500,3754625,paid,\"10xMC30C,5xMC-SC,2xViscountClass\",4243,cc27ef07a5ecc764b9c9d3cf85c620d9,Vice Admiral Holdo,vice_admiral_holdo@holdo.com\n" +
      "817f8826-aec1-4fbe-b81c-adb68b4f406c,2022-02-21 04:51:01 -0500,2022-02-21 06:24:48 -0500,2022-02-21 06:24:48 -0500,7596497,paid,\"9xMC30C,2xMC-SC,1xViscountClass\",5704,f35331c73e8ca20ab22bbb3b6d638195,Bail Organa,bail_organa@organa.com\n"
    end

    it 'maps the report details to the transactions attributes' do
      transactions = parser.parse

      expect(transactions).to eq([
        {
          currency: 'RCR',
          external_id: '3c8afb55-002f-4ed5-ae3f-7af240405662',
          intent_id:'cc27ef07a5ecc764b9c9d3cf85c620d9',
          paid_at: Time.parse('2022-02-21 06:24:48.000000000 -0500'),
          status: 'PAID',
          value_in_cents: 3754625
        },
        {
          currency: 'RCR',
          external_id: '817f8826-aec1-4fbe-b81c-adb68b4f406c',
          intent_id:'f35331c73e8ca20ab22bbb3b6d638195',
          paid_at: Time.parse('2022-02-21 06:24:48.000000000 -0500'),
          status: 'PAID',
          value_in_cents: 7596497
        }
      ])
    end
  end
end
