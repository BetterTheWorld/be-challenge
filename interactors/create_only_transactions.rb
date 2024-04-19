class CreateOnlyTransactions
  include Interactor

  def call
    process_reports
  rescue StandardError => e
    context.fail!(message: e.message, error_code: :invalid_argument)
  end

  private

  def process_reports
    reports.each do |report|
      format = report['format']
      token = account_token
      report_id = report['report_id']
      currency = report['currency']

      transactions = client.get_report_by_id(report_id, token)

      case format
      when 'json'
        filtered_transactions = transactions.uniq { |hash| hash['id'] }
        TransactionOnlyService.call(filtered_transactions, JsonSanitizer, currency)
      when 'csv'
        filtered_transactions = transactions.uniq { |hash| hash['id'] }
        TransactionOnlyService.call(filtered_transactions, CsvSanitizer, currency)
      when 'xml'
        filtered_transactions = transactions.dig('report', 'transaction').uniq { |hash| hash['id'] }
        TransactionOnlyService.call(filtered_transactions, XmlSanitizer, currency)
      else
        raise ArgumentError, "Unsupported format: #{format}"
      end
    end
  end

  delegate :reports, :client, :account_token, to: :context
end
