require 'spec_helper'

describe BasicTreatmentArm do

  context "should create valid basic treatment arm model" do

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

    it "recieved from db" do
      ba = mock_model("BasicTreatmentArm")
      ba = basic_treatment_arm
      expect(ba.treatment_arm_id).to eq("EAY131-A")
      expect(ba.treatment_arm_name).to eq("AZD9291 in TKI resistance EGFR T790M mutation")
      expect(ba.current_patients).to eq(6)
      expect(ba.former_patients).to eq(1)
      expect(ba.not_enrolled_patients).to eq(0)
      expect(ba.pending_patients).to eq(2)
      expect(ba.treatment_arm_status).to eq("OPEN")
      expect(ba.date_created).to eq("2016-03-03T19:38:37.890Z")
    end
  end

end