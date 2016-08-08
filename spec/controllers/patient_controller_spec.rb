require 'rails_helper'
require 'factory_girl_rails'

describe PatientController do

  before(:each) do
    setup_knock()
  end

  let(:patient_treatment_arm) do
    stub_model TreatmentArmPatient,
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
      expect(:get => "/patientsOnTreatmentArm/EAY131-A" ).to route_to(:controller => "patient",
                                                                      :action => "patient_on_treatment_arm",
                                                                      :id => "EAY131-A")
    end

    it "patient should handle errors correctly" do
      allow(TreatmentArmPatient).to receive(:scan).and_raise("this error")
      get :patient_on_treatment_arm, :id => "EAY131-A"
      expect(response.body).to include("this error")
      expect(response).to have_http_status(500)
    end

    # it "should pull data correctly from DB" do
    #   allow(TreatmentArmPatient).to receive(:scan).and_return(patient_treatment_arm)
    #   get :patient_on_treatment_arm, :id => "EAY131-A"
    #   expect(response.body).to eq(patient_treatment_arm.to_json)
    # end

  end

end