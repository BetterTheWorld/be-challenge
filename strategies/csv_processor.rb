require_relative './processor_strategy'
require 'csv'

class CsvProcessor < ProcessorStrategy
  def process(data, currency)
    CSV.parse(data, headers: true).map(&:to_hash).each do |row|
      Transaction.create(
        intent_id: row["id"],
        value_in_cents: row["value"],
        status: row["status"].upcase,
        paid_at: row["paid_at"],
        external_id: row["account_external_ref"],
        currency: currency,
      )
    end
  end
end