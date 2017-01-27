source 'https://rubygems.org'

gem 'newrelic_rpm'
# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '5.0.0.1'

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
gem 'active_model_serializers', '0.10.3'
gem 'aws-record'
gem 'aws-sdk', '2.6.34'
gem 'aws-sdk-rails', '1.0.1'
gem 'json-schema', '2.7.0'
gem 'nci_match_patient_models', git: 'git://github.com/CBIIT/nci-match-lib.git', tag: 'v1.1.8'
gem 'nci_match_roles', git: 'git://github.com/CBIIT/nci_match_roles.git', branch: :master
gem 'rack-cors'

# Use jquery as the JavaScript library
# gem 'jquery-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
# gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '2.6.1'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '0.4.2', group: :doc
# AuthO
gem 'auth0'
gem 'cancan'
gem 'httparty', '0.14.0'
gem 'knock', '2.0'

# Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'
  gem 'rspec-rails'
  # gem 'rspec-rails', '~> 3.0'
  gem 'factory_girl_rails', '4.5.0'
  gem 'faker'
  gem 'rspec-activemodel-mocks'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
end

group :test do
  gem 'codacy-coverage', require: false
  gem 'codeclimate-test-reporter', '~> 1.0.0'
  gem 'simplecov'
end

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Use debugger
# gem 'debugger', group: [:development, :test]
