class TransactionCreatorService
  def self.call(transactions, sanitizer_class, report)
    transactions_to_save = []

    transactions.each do |transaction|
      params = sanitizer_class.new(transaction.symbolize_keys)
      params[:currency] = report.currency
      transactions_to_save << params
    end

    report.transactions.create!(transactions_to_save)
  end
end
