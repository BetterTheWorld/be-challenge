require 'active_support/core_ext/hash/conversions'
require 'pry'

class GalacticCommerceClient
  include HTTParty

  def initialize
    @base_uri = ENV["COMMERCE_API"]
  end

  def self.instance
    new
  end

  def register(email, password)
    handle_response(post_request('/register', email: email, password: password))
  end

  def login(email, password)
    handle_response(post_request('/login', email: email, password: password))
  end

  def get_reports(token)
    handle_response(get_request('/reports', token))
  end

  def get_report_by_id(report_id, token)
    handle_response(get_request("/reports/#{report_id}", token))
  end

  private

  attr_reader :base_uri

  def post_request(endpoint, params)
    self.class.post("#{base_uri}#{endpoint}", query: params)
  end

  def get_request(endpoint, token)
    self.class.get("#{base_uri}#{endpoint}", headers: { 'Authorization' => "Bearer #{token}" })
  end

  def handle_response(response)
    return OpenStruct.new(message: response.body, code: response.code) unless response.success?

    content_type = response.headers['content-type']

    if response.parsed_response.is_a?(Hash) && response.key?('token')
      OpenStruct.new(token: response['token'])
    elsif content_type.include?('json')
      # could be reports or single report_id
      JSON.parse(response.body)
    elsif content_type.include?('charset=utf-8') && is_csv?(response.body)
      CSV.parse(response.body, headers: true).map(&:to_h)
    elsif content_type.include?('charset=utf-8') && !is_csv?(response.body)
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
end
