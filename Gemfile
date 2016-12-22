source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '5.0.0.1'
# gem 'rails', '4.2.5'
gem 'newrelic_rpm'

# Use SCSS for stylesheets
gem 'sass-rails'
# gem 'sass-rails', '~> 4.0.3'
# Use Uglifier as compressor for JavaScript assets
# gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .js.coffee assets and views
# gem 'coffee-rails', '~> 4.0.0'
# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer',  platforms: :ruby

# gem 'mongoid', '~> 5.0.0'
# gem 'mongoid-enum'
# gem 'bson_ext'
gem 'rack-cors'

gem 'aws-sdk-rails', '1.0.1'
gem 'aws-record'
gem 'json-schema', '2.7.0'
gem 'aws-sdk', '2.6.34'
gem 'active_model_serializers', '0.10.3'
gem 'nci_match_patient_models', git: 'git://github.com/CBIIT/nci-match-lib.git', branch: 'master'

# Use jquery as the JavaScript library
# gem 'jquery-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
# gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '2.6.1'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '0.4.2', group: :doc
# AuthO
gem 'knock', '2.0'
gem 'auth0'
gem 'httparty', '0.14.0'

# Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'
  gem 'rspec-rails'
  # gem 'rspec-rails', '~> 3.0'
  gem 'rspec-activemodel-mocks'
  gem 'factory_girl_rails', '4.5.0'
  gem 'faker'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
end

group :test do
  gem "simplecov"
  gem "codeclimate-test-reporter", "~> 1.0.0"
  gem 'codacy-coverage',  require: false
end

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Use debugger
# gem 'debugger', group: [:development, :test]
