class ApiClient
  class NotFoundError < StandardError; end
  class Unauthorized < StandardError; end
  class UnexpectedError < StandardError; end

  BASE_URL = 'https://be-challenge-api.herokuapp.com'
  USER_EMAIL = 'eduardo@gmail.com'
  USER_PASSWORD = 'Password1'

  def list_reports
    response = HTTParty.get(
      "#{BASE_URL}/reports",
      headers: { "Authorization" => "Bearer #{jwt_token}" }
    )

    handler_error(response) if response.code != 200

    JSON.parse(response.body)
  end

  def get_report(report_id)
    response = HTTParty.get(
      "#{BASE_URL}/reports/#{report_id}",
      headers: { "Authorization" => "Bearer #{jwt_token}" }
    )

    handler_error(response) if response.code != 200

    # The response.body could be either JSON, CSV or XML.
    # Each parsing logic will parse the response properly
    response.body
  end

  private

  def jwt_token
    return @jwt_token if @jwt_token.present?

    response = HTTParty.post(
      "#{BASE_URL}/login",
      body: {
        'email' => USER_EMAIL,
        'password' => USER_PASSWORD
      }
    )

    @jwt_token = response['token']
    @jwt_token
  end

  def handler_error(response)
    case response.code
    when 404
      raise NotFoundError.new(response.body)
    when 403
      raise Unauthorized.new(response.body)
    else
      raise UnexpectedError.new(response.body)
    end
  end
end
