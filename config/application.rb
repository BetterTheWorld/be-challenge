require 'sinatra'
require 'sinatra/base'
require 'sinatra/json'
require 'sinatra/activerecord'
require 'byebug'
require 'pry'
require 'httparty'
require 'dotenv'
require 'interactor'
require 'openssl'
require 'hashie'

set :database_file, '../config/database.yml'

# Load all necessary files!
Dir['./models/*', './services/*'].each {|file| require file }

folders = ["./interactors", "./sanitizers"]

folders.each do |folder|
  Dir.glob("#{folder}/*.rb").sort.each do |file|
    require file
  end
end

logger = Logger.new(STDOUT)
logger.formatter = proc do |severity, datetime, progname, msg|
   "#{msg}\n"
end

ActiveRecord::Base.logger = logger

Dotenv.load
