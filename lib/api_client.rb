class ApiClient
  attr_accessor :jwt_token

  BASE_URL = 'https://be-challenge-api.herokuapp.com'

  def initialize(jwt_token)
    @jwt_token = jwt_token
  end

  def list_reports
    HTTParty.get("#{BASE_URL}/reports", headers: {"Authorization" => "Bearer #{jwt_token}"})
  end

  def get_report(report_id)
    HTTParty.get("#{BASE_URL}/reports/#{report_id}", headers: {"Authorization" => "Bearer #{jwt_token}"})
  end
end
