require 'rails_helper'

describe Api::V1::VersionsController do
  describe 'GET #version' do
    it 'Should return the API version' do
      get :version
      expect(response).to have_http_status(200)
    end

    it 'should route to the correct controller' do
      expect(get: '/api/v1/treatment_arms/version').to route_to(controller: 'api/v1/versions', action: 'version')
    end

    it 'should handle an error correctly' do
      allow(TreatmentArmApi::Application).to receive(:version).and_raise('this error')
      get :version
      expect(response).to have_http_status(500)
    end
  end
end
