class AddReportIdToTransactions < ActiveRecord::Migration[6.1]
  def change
    add_reference :transactions, :report, foreign_key: true
  end
end
