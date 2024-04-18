class GetReports
  include Interactor

  def call
    context.reports = context.client.get_reports(context.organization.commerce_token)
  end

  private
end
