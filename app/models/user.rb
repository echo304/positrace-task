# frozen_string_literal: true

class User < ApplicationRecord
  has_many :api_keys, as: :bearer

  has_secure_password
end
