class CreateReports
  include Interactor

  def call
    desired_keys = ["name", "location", "currency", "symbol", "report_id", "format"]

    context.reports.each do |external_report|
      filtered_elements = external_report.select { |key, _| desired_keys.include?(key) }
      filtered_elements["external_report_id"] = filtered_elements.delete("report_id")

      report = context.organization.reports.new(filtered_elements)
      report.save if report.valid?
    end
  end

  private
end
