require 'securerandom'
require './config/application'

class Report < ActiveRecord::Base
  has_many :transactions

  belongs_to :organization 
end