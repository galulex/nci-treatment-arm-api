require 'rails_helper'
require 'factory_girl_rails'

describe TreatmentarmController do

  let(:basic_treatment_arm) do
    stub_model BasicTreatmentArm,
               :treatment_arm_id => "EAY131-A",
               :treatment_arm_name => "AZD9291 in TKI resistance EGFR T790M mutation",
               :current_patients => 6,
               :former_patients => 1 ,
               :not_enrolled_patients => 0 ,
               :pending_patients => 2 ,
               :treatment_arm_status => "OPEN" ,
               :date_created => "2016-03-03T19:38:37.890Z" ,
               :date_opened =>"2016-03-03T19:38:37.890Z" ,
               :date_closed => "2016-03-03T19:38:37.890Z" ,
               :date_suspended=> "2016-03-03T19:38:37.890Z"
  end
  
  let(:treatment_arm) do
    stub_model TreatmentArm,
               :version => "2016-20-02",
               :description => "WhoKnows",
               :target_id => "HDFD",
               :target_name => "OtherHen",
               :gene => "GENE",
               :treatment_arm_status => "BROKEN",
               :max_patients_allowed => 35,
               :num_patients_assigned => 4,
               :date_created => "2016-03-03T19:38:37.890Z",
               :treatment_arm_drugs => [],
               :variant_report => [],
               :exclusion_criterias => [],
               :exclusion_diseases => [],
               :exclusion_drugs => [],
               :pten_results => [],
               :status_log => []
               
  end

  describe "POST #newTreatmentArm" do

    context "with valid data" do
      it "should save data to the database" do
        allow(Publisher).to receive(:publish).and_return("")
        post "new_treatment_arm", {:_id => "EAY131-A"}.to_json
        expect(response).to have_http_status(200)
      end

      it "should respond with a success json message" do
        allow(Publisher).to receive(:publish).and_return("")
        post "new_treatment_arm", {:_id => "EAY131-A"}.to_json
        expect(response.body).to include("Success")
        expect(response).to have_http_status(200)
      end
    end

    context "with invalid data" do
      it "should throw a 500 status" do
        post "new_treatment_arm", {}
        expect(response).to have_http_status(500)
      end

      it "should respond with a failure json message" do
        post "new_treatment_arm", {}
        expect(response.body).to include("Failure")
        expect(response).to have_http_status(500)
      end
    end

  end


  describe "GET #treatmentArms" do

    it "should return all treatment arms if params are empty" do
      expect(:get => "/treatmentArms" ).to route_to(:controller => "treatmentarm", :action => "treatment_arms")
      expect(:get => "/treatmentArms/EAY131-A" ).to route_to(:controller => "treatmentarm", :action => "treatment_arm", :id => "EAY131-A")
      expect(:get => "/treatmentArms/EAY131-A/2016-02-20").to route_to(:controller => "treatmentarm", :action => "treatment_arm", :id => "EAY131-A", :version => "2016-02-20")
    end

    it "treatment_arms should handle errors correctly" do
      allow(TreatmentArm).to receive(:all).and_raise("this error")
      get :treatment_arms
      expect(response.body).to include("this error")
      expect(response).to have_http_status(500)
    end

    it "treatment_arm should handle errors correctly" do
      allow(TreatmentArm).to receive(:where).and_raise("this error")
      get :treatment_arm, :id => "EAY131-A"
      expect(response.body).to include("this error")
      expect(response).to have_http_status(500)
    end

    it "should return a treatmentArm if id is given" do
      allow(TreatmentArm).to receive(:where).and_return([treatment_arm])
      get :treatment_arm, :id => "EAY131-A", :version => "2016-20-02"
      expect(response.body).to eq(treatment_arm.to_json)
      expect(response).to have_http_status(200)
    end

    it "should return all treatmentArms if nothing is given" do
      allow(TreatmentArm).to receive(:all).and_return(treatment_arm)
      get :treatment_arms
      expect(response.body).to eq(treatment_arm.to_json)
      expect(response).to have_http_status(200)
    end
    

  end

  describe "GET #basicTreatmentArms" do

    it "should return the basic data for all treatment arms" do
      expect(:get => "/basicTreatmentArms").to route_to(:controller => "treatmentarm", :action => "basic_treatment_arms")
      expect(:get => "/basicTreatmentArms/EAY131-A" ).to route_to(:controller => "treatmentarm", :action => "basic_treatment_arms", :id => "EAY131-A")
    end

    it "should handle errors correctly" do
      allow(BasicTreatmentArm).to receive(:all).and_raise("this error")
      get :basic_treatment_arms
      expect(response.body).to include("this error")
      expect(response).to have_http_status(500)
    end

    it "should send the correct json back" do
      allow(BasicTreatmentArm).to receive(:all).and_return(basic_treatment_arm)
      get :basic_treatment_arms
      expect(response.body).to eq(basic_treatment_arm.to_json)
      expect(response).to have_http_status(200)
    end

  end


end