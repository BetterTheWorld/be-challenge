class GetReports
  include Interactor

  def call
    context.reports = context.client.get_reports(token)
  end

  private

  def token
    context.account_token || context.organization&.commerce_token
  end
end
