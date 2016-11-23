require 'rails_helper'

describe Api::V1::ErrorsController do
  context 'on unrecognized URL' do
    it 'should route to the correct controller' do
      expect(get: 'api/v1/treatment_arms/APEC1621-A').to route_to(controller: 'api/v1/errors', action: 'render_not_found',
             "path"=>"treatment_arms/APEC1621-A")
    end

    it 'should raise the UrlGenerationError' do
      expect { get :render_not_found, treatment_arm_id: 'APEC1621-A' }.to raise_error(ActionController::UrlGenerationError)
    end
  end
end



