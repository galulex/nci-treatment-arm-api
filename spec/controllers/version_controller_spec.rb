require 'rails_helper'

describe VersionController do

  describe "GET #version" do
    it "Should return the API version" do
      route_to('version')
      expect(response).to have_http_status(200)
    end

  end
end