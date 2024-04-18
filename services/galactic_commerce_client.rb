require 'active_support/core_ext/hash/conversions'

class GalacticCommerceClient
  include HTTParty

  def initialize
    @base_uri = "https://be-challenge-uqjcnl577q-pd.a.run.app"
  end

  def self.instance
    new # This will initialize the client
  end

  def register(email, password)
    response = post_register(email, password)

    return handle_errors(response) unless response.success?

    convert_response(response)
  end

  def login(email, password)
    response = post_login(email, password)

    return handle_errors(response) unless response.success?

    convert_response(response)
  end

  def get_reports(token)
    response = get_reports_request(token)

    return handle_errors(response) unless response.success?

    response.parsed_response # Return the parsed response
  end

  def get_report_by_id(report_id, token)
    response = get_report_by_id_request(report_id, token)

    return handle_errors(response) unless response.success?

    handle_response(response)
  end

  private

  attr_reader :base_uri

  def post_register(email, password)
    self.class.post("#{base_uri}/register",
                    query: { email: email, password: password })
  end

  def post_login(email, password)
    self.class.post("#{base_uri}/login",
                    query: { email: email, password: password })
  end

  def get_reports_request(token)
   self.class.get("#{base_uri}/reports",
                  headers: { "Authorization" => "Bearer #{token}" })
 end

 def get_report_by_id_request(report_id, token)
    self.class.get("#{base_uri}/reports/#{report_id}",
                   headers: { "Authorization" => "Bearer #{token}" })
  end

  def convert_response(response)
    OpenStruct.new(
      token: response["token"]
    )
  end

  def handle_response(response)
    raise StandardError, response.message unless response.success?

    content_type = response.headers['content-type']
    case
    when content_type.include?("json")
      JSON.parse(response.body)
    when content_type.include?("charset=utf-8") && is_csv?(response.body)
      CSV.parse(response.body, headers: true).map(&:to_h)
    when content_type.include?("charset=utf-8") && !is_csv?(response.body)
      Hash.from_xml(response.body)
    else
      raise StandardError, "Unsupported content type: #{response.headers['content-type']}"
    end
  end

  def is_csv?(body)
    CSV.parse(body).present?
  rescue CSV::MalformedCSVError
    false
  end

  def handle_errors(response)
    OpenStruct.new(
      message: response.body,
      code: response.code
    )
  end
end
