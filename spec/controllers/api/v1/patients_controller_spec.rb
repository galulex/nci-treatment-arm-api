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
end
