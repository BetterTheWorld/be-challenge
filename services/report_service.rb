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

      transactions = report_transactions(report_id, format)
      save_transactions_to_db(transactions, currency)
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
      format_xml_transaction(transactions_parsed)
    else
      transactions_parsed
    end
  end

  def format_xml_transaction(xml_string)
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

  def save_transactions_to_db(transactions_array = [], currency)
    transactions_array.each do |transaction|
      Transaction.create transaction.slice('id', 'external_id', 'paid_at', 'status')
                             .merge({ 'intent_id' => 'intent_id', 'value_in_cents' => transaction['value'], 'currency' => currency })
    end
  end

 #
 # #create User
 #  response = HTTParty.post('https://be-challenge-uqjcnl577q-pd.a.run.app/register', body: "{\"email\":\"ernesto_alcaraz12@gmail.com\",\"password\":\"test1234\"}", headers: { 'Content-Type' => 'application/json' })
 #  response.parsed_response
 #  token = response.parsed_response['token']
 #
 # # LogIn
 #  response = HTTParty.post('https://be-challenge-uqjcnl577q-pd.a.run.app/login', body: "{\"email\":\"ernesto_alcaraz12@gmail.com\",\"password\":\"test1234\"}")
 #  response.parsed_response
 #  token = response.parsed_response['token']
 #
  token = 'eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxfQ.ETUYUOkmfnWsWIvA8iBOkE2s1ZQ0V_zgnG_c4QRrhbg'
  params = {'token' => token }
  report_service = ReportService.new(params)
  report_service.save_reports_transactions_to_db

  #Get Reports
  response = HTTParty.get('https://be-challenge-uqjcnl577q-pd.a.run.app/reports', headers: { 'Authorization' => "#{token}" })
  response.parsed_response
  report_id = response.parsed_response[0]['report_id']


  CSV.foreach(a, headers: true) do |row|
    puts row.inspect # hash
  end

 # Get Report by Id
  response = HTTParty.get("https://be-challenge-uqjcnl577q-pd.a.run.app/reports/#{report_id}", headers: { 'Authorization' => "#{token}" })
  parsed_response = response.parsed_response
  reports_json.count
 #This is the obj that we want to save on the transaction table
end
