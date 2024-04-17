ENV['RACK_ENV'] = 'test'

require_relative '../app.rb'
require_relative 'support/vcr_setup'
require 'rspec'
require 'rack/test'
require 'factory_bot'
require 'faker'

RSpec.configure do |config|
  config.include Rack::Test::Methods
  config.include FactoryBot::Syntax::Methods

  config.before(:suite) do
    FactoryBot.find_definitions
  end

  # Método auxiliar para crear una nueva instancia de tu aplicación Sinatra para las pruebas
  def app
    Sinatra::Application
  end
end
