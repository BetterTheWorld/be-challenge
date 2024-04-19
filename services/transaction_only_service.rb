class TransactionOnlyService
  def self.call(transactions, sanitizer_class, currency)
    transactions_to_save = []

    transactions.each do |transaction|
      params = sanitizer_class.new(transaction.symbolize_keys)
      params[:currency] = currency
      transactions_to_save << params
    end

    Transaction.create!(transactions_to_save)
  end
end
