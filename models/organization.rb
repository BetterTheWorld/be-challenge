require './config/application'

class Organization < ActiveRecord::Base
  has_many :reports
end
