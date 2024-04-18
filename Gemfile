source "https://rubygems.org"

gem "sinatra"
gem 'sinatra-contrib'
gem "sinatra-activerecord"    # for Active Record models
gem "rake"  # so we can run Rake tasks
gem "httparty"
gem 'dotenv'

group :production do
  # Use Postgresql for ActiveRecord
  gem 'pg'
end

group :development, :test do
  # Use SQLite for ActiveRecord
  gem 'sqlite3'
  gem 'rails-erd'
  gem 'vcr'
  gem 'webmock'
  gem 'rack-test'
  gem 'rspec'
  gem 'pry'
  gem 'byebug'
end
