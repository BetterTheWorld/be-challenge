class GetReports
  include Interactor

  def call
    context.reports = context.client.get_reports(token)
  rescue StandardError => e
    context.fail!(message: e.message, error_code: :invalid_argument)
  end

  private

  def token
    context.account_token || context.organization&.commerce_token
  end
end
