require 'rails_helper'

describe VersionController do

  describe "GET #version" do
    it "Should return the API version" do
     get :version
     expect(response.body).to eq(TreatmentArmRestfulApi::Application.VERSION)
     expect(response).to have_http_status(200)
    end

    it "should route to the correct controller" do
      expect(:get => "/version" ).to route_to(:controller => "version", :action => "version")
    end

  end
end