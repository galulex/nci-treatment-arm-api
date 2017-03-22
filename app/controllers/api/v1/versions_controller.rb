# Versions Controller
# gets triggered when GET '/api/v1/treatment_arms/version'
module Api::V1
  class VersionsController < ApplicationController
    def version
      begin
        File.open('build_number.html', 'r') do |document|
          hash = {}
          document.each_line do |line|
            arr = line.split('=', 2)
            hash.store(arr[0], arr[1].squish!)
          end
          document.close
          hash[:version] = TreatmentArmApi::Application.version
          hash[:rails_version] = Rails::VERSION::STRING
          hash[:ruby_version] = RUBY_VERSION
          hash[:environment] = Rails.env
          render json: hash
        end
      rescue => error
        standard_error_message(error)
      end
    end
  end
end