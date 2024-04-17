source "https://rubygems.org"

gem "sinatra"
gem 'sinatra-contrib'
gem "sinatra-activerecord"    # for Active Record models
gem "rake"  # so we can run Rake tasks
gem 'httparty'

group :production do
  # Use Postgresql for ActiveRecord
  gem 'pg'
end

group :development, :test do
  # Use SQLite for ActiveRecord
  gem 'sqlite3'
  gem "byebug"
end

group :test do
  gem 'rspec'
  gem 'rack-test'
  gem 'vcr'
  gem 'webmock'
  gem 'factory_bot'
  gem 'faker'
end