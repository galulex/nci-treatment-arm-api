# Ping Controller
# gets triggered when GET '/api/v1/treatment_arms/ping'
module Api
  module V1
    class PingController < ApplicationController

      def ping
        render json: { status: 'SUCCESS' }, status: 200
      end
    end
  end
end