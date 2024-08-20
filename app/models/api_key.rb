# frozen_string_literal: true

class ApiKey < ApplicationRecord
  # Hardcoded secret key for HMAC digesting the API key token because this is
  # just a demo application. In a real-world application, this should be
  # stored in a secure location such as environment variables
  HMAC_SECRET_KEY = "de9131cd5976f5e55f5e55e3fa882829d6da1242ce1eb468f868c96cbb642044"

  # Virtual attribute for raw token value, allowing us to respond with the
  # API key's non-hashed token value. but only directly after creation.
  # This is not stored in the database and that's why it's not possible to get the token value after the object is created.
  attr_accessor :token

  belongs_to :bearer, polymorphic: true

  before_create :generate_token_hmac

  def self.authenticate_by_token!(token)
    digest = OpenSSL::HMAC.hexdigest 'SHA256', HMAC_SECRET_KEY, token

    find_by! token_digest: digest
  end

  def self.authenticate_by_token(token)
    authenticate_by_token! token
  rescue ActiveRecord::RecordNotFound
    nil
  end

  def serializable_hash(options = nil)
    h = super (options || {}).merge(except: 'token_digest')
    h.merge! 'token' => token if token.present?
    h
  end

  private

  def generate_token_hmac
    raise ActiveRecord::RecordInvalid, 'token is required' unless token.present?

    digest = OpenSSL::HMAC.hexdigest 'SHA256', HMAC_SECRET_KEY, token

    self.token_digest = digest
  end
end
