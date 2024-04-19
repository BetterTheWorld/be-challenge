VENDORS_INTENT_ID_REFERENCE = {
    7426 => "['account']['referrence_id']",
    4738 => 'account_external_ref',
    3745 =>'client_external_id'
}

class ReportService
  def initialize(params)
    @token = params['token']
  end

  def save_reports_transactions_to_db(reports = [])
    if reports.blank?
      response = HTTParty.get('https://be-challenge-uqjcnl577q-pd.a.run.app/reports', headers: { 'Authorization' => "#{@token}" })
      reports = response.parsed_response
    end

    reports.each do |report_hash|
      report_id = report_hash['report_id']
      currency = report_hash['currency']
      format = report_hash['format']

      report_transactions = report_transactions(report_id, format)
      transactions = sanitized_transactions(report_id, currency, report_transactions)

      save_transactions_to_db(transactions)
    end
  end

  def sanitized_transactions(report_id, currency, report_transactions)
    vendor_intent_id = VENDORS_INTENT_ID_REFERENCE[report_id]
    if report_id == 7426
      report_transactions.map do |transaction|
        transaction.slice('paid_at', 'status').merge({ 'external_id' => transaction['id'], 'intent_id' => transaction['account']['referrence_id'], 'value_in_cents' => transaction['value'], 'currency' => currency })
      end
    else
      report_transactions.map do |transaction|
        transaction.slice('paid_at', 'status').merge({ 'external_id' => transaction['id'], 'intent_id' => transaction[vendor_intent_id], 'value_in_cents' => transaction['value'], 'currency' => currency })
      end
    end
  end

  def report_transactions(report_id, format)
    response = HTTParty.get("https://be-challenge-uqjcnl577q-pd.a.run.app/reports/#{report_id}", headers: { 'Authorization' => "#{@token}" })
    transactions_parsed = response.parsed_response

    case format
    when 'csv'
      csv_file = StringIO.new(transactions_parsed)
      CSV.parse(csv_file, headers: true).map(&:to_h)
    when 'xml'
      xml_to_hash_transactions(transactions_parsed)
    else
      transactions_parsed
    end
  end

  def xml_to_hash_transactions(xml_string)
    doc = Nokogiri::XML(xml_string)
    transactions = []
    doc.xpath('//transaction').each do |record|
      hash = {}
      record.children.each do |element|
        hash[element.name] = element.text
      end
      transactions << hash
    end

    transactions
  end

  def save_transactions_to_db(transactions_array = [])
    transactions_array.each do |transaction_hash|
      begin
        transaction_obj = Transaction.find_or_initialize_by(external_id: transaction_hash['external_id'])
        transaction_obj.update(transaction_hash)
      rescue Exception
        binding.pry
      end
    end
  end
end
