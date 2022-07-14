class ReportsImporter
  JWT_TOKEN = "eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjo1fQ.OMK7-WIm6xwEM1inhy7MakzQCr95RVO0eWCmo3FpYww"

  def import
    reports = api_client.list_reports

    reports.each do |report|
      report_details = api_client.get_report(report['report_id'])
      parser = ReportDetailsParserFactory.build(report, report_details)

      transactions = parser.parse

      transactions_creator = TransactionsCreator.new(transactions)
      transactions_creator.create!
    rescue NotImplementedError => e
      puts e # Log error
    end
  end

  private

  def api_client
    @api_client ||= ApiClient.new(JWT_TOKEN)
  end
end
