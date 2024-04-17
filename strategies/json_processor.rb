require_relative './processor_strategy'

class JsonProcessor < ProcessorStrategy
  def process(data, currency)
    JSON.parse(data).each do |item|
      Transaction.create(
        intent_id: item["id"],
        value_in_cents: item["value"],
        status: item["status"].upcase,
        paid_at: item["paid_at"],
        external_id: item["account"]["referrence_id"],
        currency: currency,
      )
    end
  end
end