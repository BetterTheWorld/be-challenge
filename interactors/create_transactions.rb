class CreateTransactions
  include Interactor

  def call
    organization.reports.each do |report|
      format = report.format
      token = organization.commerce_token
      report_id = report.external_report_id
      transactions = client.get_report_by_id(report_id, token)

      case format
      when 'json'
        # there are duplicated ids
        filetered_transactions = transactions.uniq { |hash| hash['id'] }
        TransactionCreatorService.call(filetered_transactions, JsonSanitizer, report)
      when 'csv'
        # there are duplicated ids
        filetered_transactions = transactions.uniq { |hash| hash['id'] }
        TransactionCreatorService.call(filetered_transactions, CsvSanitizer, report)
      when 'xml'
        filetered_transactions = transactions.dig('report', 'transaction').uniq { |hash| hash['id'] }
        TransactionCreatorService.call(filetered_transactions, XmlSanitizer, report)
      else
        raise ArgumentError, "Unsupported format: #{format}"
      end
    end
  end

  private

  delegate :organization, :client, to: :context
end
