class User
  include ActiveModel::SecurePassword
  has_secure_password

  def self.from_token_payload payload
    Rails.logger.info "====== payload: #{payload} ======"
    payload.deep_symbolize_keys!
    return false if payload.blank? || payload.values_at(:roles, :sub, :email).include?(nil)
    payload
  end
end