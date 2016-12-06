# Versions Controller
# gets triggered when GET '/api/v1/treatment_arms/version'
module Api
  module V1
    class VersionsController < ApplicationController
      def version
        begin
          response = {
                       :"version" => TreatmentArmApi::Application.VERSION,
                       :"rails version" => Rails::VERSION::STRING,
                       :"ruby version" => RUBY_VERSION,
                       :"commit" => `git rev-parse HEAD`.tr("\n",""),
                       :"author" => `git --no-pager show -s --format='%an <%ae>'`.tr("\n",""),
                       :"timestamp" => `git log -1 --format=%cd`.tr("\n",""),
                       :"environment" => Rails.env
                     }
          respond_to do |format|
            format.json  { render json: response }
          end
        rescue => error
          standard_error_message(error)
        end
      end

      private

      def standard_error_message(error)
        logger.error error.message
        render json: error.to_json, status: 500
      end
    end
  end
end