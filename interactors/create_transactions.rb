class CreateTransactions
  include Interactor

  def call
    context.organization.reports.each do |report|
      format = report.format
      token = context.organization.commerce_token
      report_id = report.external_report_id
      transactions = context.client.get_report_by_id(report_id, token)

      if ["json", "csv"].include? format
        transactions.uniq { |h| h["id"] }.each do |transaction|
          case report.format
          when "json"
            transaction.symbolize_keys
            params = JsonSanitizer.new(transaction.symbolize_keys).to_h
            params[:currency] = report.currency
            transaction = report.transactions.new(params)
            transaction.save
          when "csv"
            transaction.symbolize_keys
            params = CsvSanitizer.new(transaction.symbolize_keys).to_h
            params[:currency] = report.currency
            transaction = report.transactions.new(params)
            transaction.save
          end
        end
      else
        # xml stuff
        transactions.dig("report", "transaction").uniq { |h| h["id"] }.each do |transaction|
          transaction.symbolize_keys
          params = XmlSanitizer.new(transaction.symbolize_keys).to_h
          params[:currency] = report.currency
          transaction = report.transactions.new(params)
          transaction.save
        end
      end
    end
  end

  private
end
