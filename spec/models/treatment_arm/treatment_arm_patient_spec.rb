require 'spec_helper'

describe TreatmentArmPatient do

  context "should create valid treatment_arm_patient model" do

    let(:treatment_arm_patient) do
      stub_model TreatmentArmPatient,
                 :patient_sequence_number => "213re",
                 :version => "2016-20-03",
                 :description => "description",
                 :target_id => "eay131",
                 :target_name => "name",
                 :gene => "gene",
                 :treatment_arm_status => "PENDING"
    end

    it "recieved from db" do
      ba = mock_model("TreatmentArmPatient")
      ba = treatment_arm_patient
      expect(ba.patient_sequence_number).to eq("213re")
      expect(ba.version).to eq("2016-20-03")
      expect(ba.description).to eq("description")
      expect(ba.target_id).to eq("eay131")
      expect(ba.target_name).to eq("name")
      expect(ba.gene).to eq("gene")
      expect(ba.treatment_arm_status).to eq("PENDING")
    end
  end

end