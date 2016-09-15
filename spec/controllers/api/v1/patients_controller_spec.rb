require 'rails_helper'
require 'factory_girl_rails'

describe Api::V1::PatientsController do

  before(:each) do
    setup_knock()
  end

  let(:patient_treatment_arm) do
    stub_model TreatmentArmAssignmentEvent,
               :id => "",
               :treatment_arm_name_version => "",
               :patient_sequence_number => "",
               :concordance => "",
               :current_patient_status => "",
               :date_created => "",
               :description => "",
               :diseases => [],
               :exclusion_criterias => [],
               :exclusion_diseases => [],
               :exclusion_drugs => [],
               :gene => "",
               :max_patients_allowed => 32,
               :name => "",
               :num_patients_assigned => 0,
               :patient_assignments => [],
               :pten_results => [],
               :target_id => "",
               :target_name => "",
               :treatment_arm_drugs => [],
               :treatment_arm_status => "",
               :variant_report => [],
               :version => "",
               :status_log => {},
               :current_step_number => 0
  end

  describe "GET #patientsOnTreatmentArm" do
    it "should route to the correct controller" do
      expect(:get => "api/v1/patients_on_treatment_arm/EAY131-A").to route_to(:controller => "api/v1/patients",
                                                                              :action => "patient_on_treatment_arm",
                                                                              :id => "EAY131-A")

      expect(:get => "/api/v1/patient_ready_for_assignment").to route_to(:controller => "api/v1/patients",
                                                                         :action => "queue_treatment_arm_assignment")
    end

    it "patient should handle errors correctly" do
      allow(TreatmentArmAssignmentEvent).to receive(:scan).and_raise("this error")
      get :patient_on_treatment_arm, id: 'EAY131-A'
      expect(response).to have_http_status(500)
    end

    it "should pull data correctly from DB" do
      allow(TreatmentArmAssignmentEvent).to receive(:scan).and_return(patient_treatment_arm)
      get :patient_on_treatment_arm, id: 'EAY131-A'
      expect(response).to_not be_nil
    end
  end

  describe "POST #patient_assignment" do
    context "With Valid Data" do
      it "Should route to the correct controller" do
        expect(:post => "/api/v1/patient_assignment").to route_to(:controller => "api/v1/patients",
                                                                  :action => "patient_assignment")
      end

      it "Should save date to the DataBase" do
        params = { treatment_arm_id: "EAY131-A", stratum_id: "100", version: "2017-10-07"}
        post :patient_assignment, params.to_json, params.merge(format: 'json')
        expect(response).to have_http_status(200)
      end
    end

    context "With Invalid Data" do
      it "Should fail saving data to the DataBase" do
        post :patient_assignment, id: 'EAY131-A'
        expect(response).to have_http_status(500)
      end
    end
  end
end
