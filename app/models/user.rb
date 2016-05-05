class User
  include Dynamoid::Document
  include ActiveModel::SecurePassword

  field :user_id
  field :password_digest
  #
  # has_secure_password

end