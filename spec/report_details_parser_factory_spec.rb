require 'spec_helper'

RSpec.describe ReportDetailsParserFactory do
  describe '#build' do
    let(:report) do
      {
        'id' => 7654,
        'format' => format,
        'symbol' => 'RCR'
      }
    end

    let(:report_details) do
      [
        {
          'id' => 'a98b535d-afa1-44ef-91fe-b1e8bc09de53',
          'created_at' => '2022-02-20 18:54:46 -0500',
          'placed_at' => '2022-02-20 19:09:31 -0500',
          'paid_at' => '2022-02-20 19:09:31 -0500',
          'value' => 7927282,
          'status' => 'paid',
          'account' => {
            'id' => 2285,
            'email' => '2285@galacticsenate.com',
            'referrence_id' => '6f9fac12b035757edd1c0983da525fed'
          }
        }
      ]
    end

    context 'when report format is json' do
      let(:format) { 'json' }

      it 'initializes a json parser' do
        expect(described_class.build(report, report_details))
          .to be_instance_of(JsonReportDetailsParser)
      end
    end

    context 'when report format is not supported' do
      let(:format) { 'unsupported' }

      it 'raises not implemented error' do
        expect{
          described_class.build(report, report_details)
        }.to raise_error(NotImplementedError, /format not supported/)
      end
    end
  end
end
