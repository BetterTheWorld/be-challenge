require_relative './processor_strategy'
require 'nokogiri'

class XmlProcessor < ProcessorStrategy
  def process(data, currency)
    doc = Nokogiri::XML(data)

    hash_from_xml(doc).each do |item|
      Transaction.create(
        intent_id: item[:id],
        value_in_cents: item[:value],
        status: item[:status].upcase,
        paid_at: item[:paid_at],
        external_id: item[:client_external_id] ,
        currency: currency,
      )
    end
  end

  private

  def hash_from_xml(doc)
    transactions = doc.xpath('//transaction')
    transactions.map do |transaction_node|
      {
        id: text_for(transaction_node, 'id'),
        created_at: text_for(transaction_node, 'created_at'),
        placed_at: text_for(transaction_node, 'placed_at'),
        paid_at: text_for(transaction_node, 'paid_at'),
        value: text_for(transaction_node, 'value').to_i,
        status: text_for(transaction_node, 'status'),
        manifest: text_for(transaction_node, 'manifest'),
        shipping: text_for(transaction_node, 'shipping'),
        client_id: text_for(transaction_node, 'client_id'),
        client_external_id: text_for(transaction_node, 'client_external_id'),
        client_name: text_for(transaction_node, 'client_name'),
        client_contact: text_for(transaction_node, 'client_contact')
      }
    end
  end

  def text_for(node, child_name)
    child = node.at_xpath(".//#{child_name}")
    child ? child.text : nil
  end
end
