require 'rails_helper'
require 'factory_girl_rails'

describe Api::V1::TreatmentArmsController do

  before(:each) do
    setup_knock()
  end

  let(:basic_treatment_arm) do
    stub_model TreatmentArm,
               :name => "",
               :treatment_arm_status => "BROKEN",
               :date_opened => "",
               :date_closed => "",
               :current_patients => 0,
               :former_patients => 1,
               :not_enrolled_patients => 2,
               :pending_patients => 0
  end

  let(:treatment_arm) do
    stub_model TreatmentArm,
               :version => "2016-20-02",
               :stratum_id => "12",
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

  describe "POST #treatment_arm" do
    context "with valid data" do
      it "should save data to the database" do
        allow(Aws::Publisher).to receive(:publish).and_return("")
        allow(JSON::Validator).to receive(:validate).and_return(true)
        params = { id: "EAY131-A", stratum_id: "100", version: "2017-10-07"}
        post :create, params.to_json, params.merge(format: 'json')
        expect(response).to have_http_status(200)
      end

      it "should respond with a success json message" do
        allow(Aws::Publisher).to receive(:publish).and_return("")
        allow(JSON::Validator).to receive(:validate).and_return(true)
        params = { id: "EAY131-A", stratum_id: "100", version: "2017-10-07"}
        post :create, params.to_json, params.merge(format: 'json')
        expect(response.body).to include("Message has been processed successfully")
        expect(response).to have_http_status(200)
      end

      # it "should respond with a failure json message" do
      #   #allow(Aws::Publisher).to receive(:publish).and_return("")
      #   allow(JSON::Validator).to receive(:validate).and_return(false)
      #   params = { stratum_id: "100", version: "2017-10-07"}
      #   post :create, params.to_json, params.merge(format: 'json')
      #   expect(response.body).to include("The property '#/' did not contain a required property of 'name'")
      #   expect(response).to have_http_status(500)
      # end
    end
  end


    # context "with invalid data" do
    #   it "should throw a 500 status" do
    #     allow(JSON::Validator).to receive(:validate).and_return(false)
    #     params = { }
    #     post :create, params.to_json, params.merge(format: 'json')
    #     expect(response).to have_http_status(500)
    #     expect(response.body).to include("A JSON text must at least contain two octets!")
    #   end
    # end

  # end

  describe "PUT #treatment_arm" do
    it "should route to the correct controller" do
      expect(:put => "api/v1/treatment_arms/EAY131-A/100/2016-10-07" ).to route_to(:controller => "api/v1/treatment_arms", :action => "update_clone",
             :id => "EAY131-A", :stratum_id => "100", :version => "2016-10-07")
    end
  end


  describe "GET #treatment_arms" do

    it "should map to the correct controller" do
      expect(:get => "api/v1/treatment_arms" ).to route_to(:controller => "api/v1/treatment_arms", :action => "index")
      expect(:get => "api/v1/treatment_arms/EAY131-A/100" ).to route_to(:controller => "api/v1/treatment_arms", :action => "index",
             :id => "EAY131-A", :stratum_id => "100")
    end

    it "should retrieve a specific treatment_arm" do
      expect(:get => "api/v1/treatment_arms/EAY131-A/100/2016-10-07" ).to route_to(:controller => "api/v1/treatment_arms", :action => "show",
             :id => "EAY131-A", :stratum_id => "100", :version => "2016-10-07")
    end

    it "treatment_arm should handle errors correctly" do
      allow(TreatmentArm).to receive(:scan).and_raise("this error")
      get :index, :id => "EAY131-A"
      expect(response).to have_http_status(200)
    end


    it "should return all treatment_arms if nothing is given" do
      allow(TreatmentArm).to receive(:scan).and_return([treatment_arm])
      get :index, { :format => :json }
      expect(response).to_not be_nil
      expect(response).to have_http_status(200)
    end

    it "should return all treatmentArms with id and stratum_id" do
      allow(TreatmentArm).to receive(:scan).and_return([treatment_arm])
      get :index, :id => "EAY131-A", :stratum_id => "100"
      expect(response).to_not be_nil
      expect(response).to have_http_status(200)
    end

  #   it "should return all treatmentArms with id, stratum_id, version" do
  #     allow(TreatmentArm).to receive(:scan).and_return([treatment_arm])
  #     get :treatment_arm, :id => "EAY131-A", :stratum_id => "12", :version => "2016-20-02"
  #     expect(response.body).to eq((treatment_arm.to_h).to_json)
  #     expect(response).to have_http_status(200)
  #   end
end

  # end

    describe "GET #basicTreatmentArms" do
   #  it "should return the basic data for all treatment arms" do
   #    expect(:get => "api/v1/treatment_arms?basic=true").to route_to(:controller => "api/v1/treatment_arms", :action => "index")
   #    #expect(:get => "/basicTreatmentArms/EAY131-A" ).to route_to(:controller => "treatmentarm", :action => "basic_treatment_arms", :id => "EAY131-A")
   #  end

  #   it "should handle errors correctly" do
  #     allow(TreatmentArm).to receive(:scan).and_raise("this error")
  #     get :basic_treatment_arms
  #     expect(response.body).to include("this error")
  #     expect(response).to have_http_status(500)
  #   end

    it "should send the correct json back" do
      allow(TreatmentArm).to receive(:scan).and_return([basic_treatment_arm])
      get :index, { basic: 'true' }
      #expect(response.body).to eq(([basic_treatment_arm.to_h]).to_json)
      expect(response).to have_http_status(200)
    end
  end
end
