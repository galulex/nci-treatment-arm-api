# Versions Controller
module Api::V1
  # gets triggered when GET '/api/v1/treatment_arms/version'
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
          hash['Build URL'] = "https://github.com/CBIIT/nci-treatment-arm-api/commit/#{hash['Commit']}"
          hash['Travis Build URL'] = "https://travis-ci.org/CBIIT/nci-treatment-arm-api/builds/#{hash['TravisBuildID']}"
          hash['Version'] = TreatmentArmApi::Application.version
          hash['Rails Version'] = Rails::VERSION::STRING
          hash['Ruby Version'] = RUBY_VERSION
          hash['Environment'] = Rails.env
          render json: hash
        end
      rescue => error
        standard_error_message(error)
      end
    end
  end
end
