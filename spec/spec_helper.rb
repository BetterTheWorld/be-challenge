ENV['APP_ENV'] = 'test'

require 'vcr'
require 'webmock'
require 'dotenv'
require 'database_cleaner/active_record'
require 'interactor'
require 'hashie'
require 'pry'

Dotenv.load

folders = ["./interactors", "./sanitizers"]

folders.each do |folder|
  Dir.glob("#{folder}/*.rb").sort.each do |file|
    require file
  end
end

RSpec.configure do |config|
  VCR.configure do |config|
    config.cassette_library_dir = 'spec/fixtures/vcr_cassettes/'
    config.hook_into :webmock
    config.default_cassette_options = { record: :once }
    config.configure_rspec_metadata!
  end

  config.before do
    ActiveRecord::Base.logger.level = 1
  end

  DatabaseCleaner.strategy = :truncation

  config.before do
    DatabaseCleaner.clean
  end

  config.after do
    DatabaseCleaner.clean
  end

  config.order = 'default'
end
