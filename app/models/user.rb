class User
  include ActiveModel::SecurePassword
  has_secure_password

  def self.from_token_payload payload
    Rails.logger.info "====== payload: #{payload} ======"
    !payload.blank?
  end
end