
require 'rails_helper'
require 'factory_girl_rails'

describe GraphDataController, :type => :controller do
  describe "get #patientStatusGraph" do
    context "with valid data" do

      it "route to correct controller" do
        expect(:get => "/patientStatusGraph" ).to route_to(:controller => "graph_data", :action => "patient_status_count")
        expect(:get => "/patientStatusGraph/EAY131-A" ).to route_to(:controller => "graph_data", :action => "patient_status_count", :id => "EAY131-A")
      end


      it "should get patientStatusGraph data" do
        data = build_stubbed(:patient_status_graph)
        allow(StatusPieData).to receive(:all).and_return(data)
        get :patient_status_count
        expect(response.body).to eq(data.to_json)
        expect(response).to have_http_status(200)
      end

      it "should handle errors correctly" do
        data = build_stubbed(:patient_status_graph)
        allow(StatusPieData).to receive(:all).and_raise("this error")
        get :patient_status_count
        expect(response).to have_http_status(500)
      end
    end

    it "should accept an id and get the correct patientStatusGraph data" do
      data = build_stubbed(:patient_status_graph)
      allow(StatusPieData).to receive(:where).and_return(data)
      get :patient_status_count, :id => "EAY131-B"
      expect(response.body).to eq(data.to_json)
      expect(response).to have_http_status(200)
    end

  end


  describe "get #patientDiseaseGraph" do

    context "with valid data" do

      it "should route to correct controller" do
        expect(:get => "/patientDiseaseGraph" ).to route_to(:controller => "graph_data", :action => "patient_disease_data")
        expect(:get => "/patientDiseaseGraph/EAY131-A" ).to route_to(:controller => "graph_data", :action => "patient_disease_data", :id => "EAY131-A")
      end

      it "should get all patientDiseaseGraph data when nothing is given on call" do
        ta = build_stubbed(:patient_disease_graph)
        allow(DiseasePieData).to receive(:all).and_return(ta)
        get :patient_disease_data
        expect(response).to have_http_status(200)
        expect(response.body).to eq(ta.to_json)
      end

      it "accept an id and get the correct patientDiseaseGraph data" do
        ta = build_stubbed(:patient_disease_graph)
        allow(DiseasePieData).to receive(:where).and_return(ta)
        get :patient_disease_data, :id => ta.id
        expect(response).to have_http_status(200)
        expect(response.body).to eq(ta.to_json)
      end
    end

    context "with invalid data"

  end
end