class CreateOnlyTransactions
  include Interactor

  def call
    reports.each do |report|
      format = report['format']
      token = context.account_token
      report_id = report['report_id']
      currency = report['currency']

      transactions = client.get_report_by_id(report_id, token)

      case format
      when 'json'
        filetered_transactions = transactions.uniq { |hash| hash['id'] }

        TransactionOnlyService.call(filetered_transactions, JsonSanitizer, currency)
      when 'csv'
        filetered_transactions = transactions.uniq { |hash| hash['id'] }

        TransactionOnlyService.call(filetered_transactions, CsvSanitizer, currency)
      when 'xml'
        filetered_transactions = transactions.dig('report', 'transaction').uniq { |hash| hash['id'] }

        TransactionOnlyService.call(filetered_transactions, XmlSanitizer, currency)
      else
        raise ArgumentError, "Unsupported format: #{format}"
      end
    end
  end

  private

  delegate :reports, :client, to: :context
end
