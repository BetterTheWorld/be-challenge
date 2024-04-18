require 'vcr'
require 'webmock'
require 'dotenv'

Dotenv.load

VCR.configure do |config|
  config.cassette_library_dir = 'spec/fixtures/vcr_cassettes/'
  config.hook_into :webmock
  config.default_cassette_options = { record: :once }
  config.configure_rspec_metadata!
end
