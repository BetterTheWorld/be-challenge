require 'spec_helper'

RSpec.describe JsonReportDetailsParser do
  describe '#parse' do
    let(:parser) { described_class.new(report, report_details) }
    let(:report) do
      {
        'id' => 7654,
        'format' => 'json',
        'symbol' => 'RCR'
      }
    end

    let(:report_details) do
      "[{\"id\":\"a98b535d-afa1-44ef-91fe-b1e8bc09de53\",\"created_at\":\"2022-02-20 18:54:46 -0500\",\"placed_at\":\"2022-02-20 19:09:31 -0500\",\"paid_at\":\"2022-02-20 19:09:31 -0500\",\"value\":7927282,\"status\":\"paid\",\"account\":{\"id\":2285,\"email\":\"2285@galacticsenate.com\",\"referrence_id\":\"6f9fac12b035757edd1c0983da525fed\"}},{\"id\":\"a98b535d-afa1-44ef-91fe-b1e8bc09de53\",\"created_at\":\"2022-02-20 18:54:46 -0500\",\"placed_at\":\"2022-02-20 19:09:31 -0500\",\"paid_at\":\"2022-02-20 19:09:31 -0500\",\"value\":4386451,\"status\":\"partial_refund\",\"account\":{\"id\":2285,\"email\":\"2285@galacticsenate.com\",\"referrence_id\":\"6f9fac12b035757edd1c0983da525fed\"}}]"
    end

    it 'maps the report details to the transactions attributes' do
      transactions = parser.parse

      expect(transactions).to eq([
        {
          currency: 'RCR',
          external_id: 'a98b535d-afa1-44ef-91fe-b1e8bc09de53',
          intent_id:'6f9fac12b035757edd1c0983da525fed',
          paid_at: Time.parse('2022-02-20 19:09:31.000000000 -0500'),
          status: 'PAID',
          value_in_cents: 792728200
        },
        {
          currency: 'RCR',
          external_id: 'a98b535d-afa1-44ef-91fe-b1e8bc09de53',
          intent_id:'6f9fac12b035757edd1c0983da525fed',
          paid_at: Time.parse('2022-02-20 19:09:31.000000000 -0500'),
          status: 'PARTIALLY_REFUNDED',
          value_in_cents: 438645100
        }
      ])
    end
  end
end
