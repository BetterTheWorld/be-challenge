class JsonReportDetailsParser
  def initialize(report, report_details)
    @report = report
    @report_details = report_details
    @transactions = []
  end

  def parse
    json_file.each do |transaction|
      @transactions << map_transaction(transaction)
    end

    @transactions
  end

  private

  def map_transaction(transaction)
    {
      intent_id: transaction['account']['referrence_id'],
      value_in_cents: transaction['value'] * 100,
      status: map_status(transaction['status']),
      paid_at: Time.parse(transaction['paid_at']),
      external_id: transaction['id'],
      currency: @report['symbol']
    }
  end

  def map_status(original_status)
    case original_status
    when 'paid'
      'PAID'
    when 'partial_refund'
      'PARTIALLY_REFUNDED'
    end
  end

  def json_file
    @json_file ||= JSON.parse(@report_details)
  end
end
