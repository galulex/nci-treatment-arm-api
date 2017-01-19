# Ping Controller
# gets triggered when GET '/api/v1/treatment_arms/ping'
module Api::V1
  class PingController < ApplicationController
    def ping
      render json: { status: 'SUCCESS' }, status: 200
    end
  end
end
