require 'sinatra'
require 'sinatra/base'
require 'sinatra/json'
require 'sinatra/activerecord'
require 'byebug'
require 'pry'
require 'httparty'
require 'dotenv'

set :database_file, '../config/database.yml'

# Load all necessary files!
Dir['./models/*', './services/*'].each {|file| require file }

logger = Logger.new(STDOUT)
logger.formatter = proc do |severity, datetime, progname, msg|
   "#{msg}\n"
end

ActiveRecord::Base.logger = logger

Dotenv.load
