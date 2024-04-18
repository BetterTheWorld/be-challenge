require 'securerandom'
require './config/application'

class Transaction < ActiveRecord::Base

  VALID_STATUSES = %w(PENDING PAID REFUNDED PARTIALLY_REFUNDED VOID).freeze

  belongs_to :report 

  before_save :generate_id

  validate :valid_status

  private

  def generate_id
    self.id ||= SecureRandom.hex
  end

  def valid_status
    VALID_STATUSES.include?(self.status)
  end

end
