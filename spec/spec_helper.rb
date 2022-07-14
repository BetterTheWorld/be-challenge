ENV['APP_ENV'] = 'test'

require './models/transaction'
Dir["#{__dir__}/../lib/*.rb"].each {|file| require file }

require 'rspec'
