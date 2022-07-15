class TransactionsCreator
  def initialize(transactions)
    @transactions = transactions
  end

  def create!
    ActiveRecord::Base.transaction do
      @transactions.each do |transaction_attributes|
        transaction = Transaction.find_by(external_id: transaction_attributes[:external_id])

        if transaction.present?
          # I assumed that when the several transactions have the same external_id
          # (e.g., for a refunded transaction), the latest transaction is the up-to-date
          # transaction, so I update all the attributes
          transaction.update!(transaction_attributes)
        else
          Transaction.create!(transaction_attributes)
        end
      end
    end
  end
end
