class User
  include Aws::Record
  include ActiveModel::SecurePassword

  string_attr :user_id
  string_attr :password_digest

  # has_secure_password

end