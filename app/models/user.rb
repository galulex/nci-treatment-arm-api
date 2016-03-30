class User
  include Mongoid::Document
  include Mongoid::Attributes::Dynamic
  include ActiveModel::SecurePassword

  # field :user_id
  # field :password_digest
  #
  # has_secure_password

end