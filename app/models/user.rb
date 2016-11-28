class User
  include ActiveModel::SecurePassword
  has_secure_password

  def self.from_token_payload payload
    !payload.blank?
  end
end