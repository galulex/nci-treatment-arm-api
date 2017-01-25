require 'rails_helper'

describe Api::V1::PingController do
  describe 'GET #Ping' do
    it 'Should return the Ping Status' do
      get :ping
      expect(response.body).to eq("{\"status\":\"SUCCESS\"}")
      expect(response).to have_http_status(200)
    end

    it 'should route to the correct controller' do
      expect(get: '/api/v1/treatment_arms/ping').to route_to(controller: 'api/v1/ping', action: 'ping')
    end
  end
end
