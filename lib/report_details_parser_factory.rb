class ReportDetailsParserFactory
  def self.build(report, report_details)
    case report['format']
    when 'json'
      JsonReportDetailsParser.new(report, report_details)
    when 'csv'
      CsvReportDetailsParser.new(report, report_details)
    else
      raise NotImplementedError.new('format not supported')
    end
  end
end
