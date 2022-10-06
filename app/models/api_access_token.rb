# frozen_string_literal: true
class ApiAccessToken < ApplicationRecord
  belongs_to :user

  before_create :generate_keys

  private

  def generate_keys
    loop do
      break if ApiAccessToken.find_by(key: key).blank?
    end
  end
end
