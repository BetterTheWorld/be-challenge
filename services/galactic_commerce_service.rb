require 'httparty'

class GalacticCommerceService
  include HTTParty

  base_uri 'https://be-challenge-uqjcnl577q-pd.a.run.app'

  attr_accessor :jwt, :response, :reports

   # Registra un nuevo usuario
  def register(email:, password:)
    handle_http_errors do
      @response = self.class.post('/register', body: { email: email, password: password })

      @jwt = JSON.parse(response.body).fetch("token")
    end
  end

  # Inicia sesión de un usuario
  def login(email:, password:)
    handle_http_errors do
      @response = self.class.post('/login', body: { email: email, password: password })

      @jwt = JSON.parse(response.body).fetch("token")
    end
  end

  # Obtiene la lista de reportes
  def fetch_reports
    handle_http_errors do
      @response = self.class.get('/reports', headers: { "Authorization" => "Bearer #{jwt}" })
      @reports = JSON.parse(response.body)

      return reports unless block_given?

      reports.each { |report| yield report }
    end
  end

  def process_report(report_id:, currency:)
    handle_http_errors do
      @response = self.class.get("/reports/#{report_id}", headers: { "Authorization" => "Bearer #{jwt}" })
    
      handle_response(response, currency)
    end
  end

  private

  def handle_http_errors
    yield
  rescue HTTParty::Error => e
    { error: "HTTParty error occurred: #{e.message}" }
  rescue StandardError => e
    { error: "Standard error occurred: #{e.message}" }
  end

  def handle_response(response, currency)
    if response.code == 200
      processor = select_processor(response)
      processor.process(response.body, currency)
    else
      { error: "API returned status code #{response.code}: #{response.parsed_response['message'] || response.message}" }
    end
  end

  def select_processor(response)
    return JsonProcessor.new if response.body.strip.start_with?('{', '[')
    return XmlProcessor.new  if response.body.strip.start_with?('<')
    return CsvProcessor.new  if response.body.include?(',')
    
    raise "Unsupported content type"
  end
end