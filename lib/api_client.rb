class ApiClient
  attr_accessor :jwt_token

  class ApiClientError < StandardError; end

  BASE_URL = 'https://be-challenge-api.herokuapp.com'

  def initialize(jwt_token)
    @jwt_token = jwt_token
  end

  def list_reports
    response = HTTParty.get("#{BASE_URL}/reports", headers: {"Authorization" => "Bearer #{jwt_token}"})

    raise ApiClientError.new(response.body) if response.code != 200

    JSON.parse(response.body)
  end

  def get_report(report_id)
    response = HTTParty.get("#{BASE_URL}/reports/#{report_id}", headers: {"Authorization" => "Bearer #{jwt_token}"})

    raise ApiClientError.new(response.body) if response.code != 200

    # The response.body could be either JSON, CSV or XML.
    # Each parsing logic will parse the response properly
    response.body
  end
end
