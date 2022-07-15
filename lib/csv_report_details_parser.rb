class CsvReportDetailsParser
  def initialize(report, report_details)
    @report = report
    @report_details = report_details
    @transactions = []
  end

  def parse
    csv_file.each do |transaction|
      @transactions << map_transaction(transaction)
    end

    @transactions
  end

  private

  def map_transaction(transaction)
    {
      intent_id: transaction['account_external_ref'],
      value_in_cents: transaction['value'].to_i,
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

  def csv_file
    @csv_file ||= CSV.parse(@report_details, headers: true)
  end
end
