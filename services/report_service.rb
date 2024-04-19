VENDORS_INTENT_ID_REFERENCE = {
    7426 => "['account']['referrence_id']",
    4738 => 'account_external_ref',
    3745 => 'client_external_id'
}

class ReportService
  def initialize(params)
    @token = params['token']
  end

  def save_reports_transactions_to_db(reports = [])
    reports = get_reports if reports.blank?

    reports.each do |report_hash|
      report_id = report_hash['report_id']
      currency = report_hash['currency']
      format = report_hash['format']

      report_transactions = report_transactions(report_id, format)
      transactions = sanitized_transactions(report_id, currency, report_transactions)

      save_transactions_to_db(transactions)
    end
  rescue StandardError => e
    "#{e.message} - Check your Auth token"
  end

  def get_reports
    response = HTTParty.get('https://be-challenge-uqjcnl577q-pd.a.run.app/reports', headers: { 'Authorization' => "#{@token}" })
    raise StandardError, "Bad request error code: #{response.code}" unless response.code == 200

    response.parsed_response
  end

  def sanitized_transactions(report_id, currency, report_transactions)
    intent_id_lambda = lambda { |report_id, transaction|
      if report_id == 7426
        transaction['account']['referrence_id']
      else
        transaction[VENDORS_INTENT_ID_REFERENCE[report_id]]
      end
    }

    report_transactions.map do |transaction|
      transaction.slice('paid_at', 'status')
                 .merge({ 'external_id' => transaction['id'], 'intent_id' => intent_id_lambda.call(report_id, transaction),
                   'value_in_cents' => transaction['value'], 'currency' => currency })
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
      transaction_obj = Transaction.find_or_initialize_by(external_id: transaction_hash['external_id'])
      transaction_obj.update(transaction_hash)
    end
  end
end
