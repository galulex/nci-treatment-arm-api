require 'spec_helper'

describe BasicTreatmentArm do

  context "should create valid basic treatment arm model" do

    let(:api_requests) { [] }

    let(:stub_client) do
      requests = api_requests
      client = Aws::DynamoDB::Client.new(stub_responses: true)
      client.handle do |context|
        requests << context.params
        @handler.call(context)
      end
      client
    end

    let(:basic_treatment_arm) do
      ba = BasicTreatmentArm.new
      ba.treatment_arm_id = "EAY131-A"
      ba.description = "TestDescription"
      ba.treatment_arm_status = "OPEN"
      ba.date_created = "2016-01-11"
      ba.date_opened = "2016-03-20"
      ba.current_patients = 0
      ba.former_patients = 3
      ba.not_enrolled_patients = 2
      ba.pending_patients = 1
      ba
    end

    # let(:basic_treatment_arm) do
    #   stub_model BasicTreatmentArm,
    #              :treatment_arm_id => "EAY131-A",
    #              :treatment_arm_name => "AZD9291 in TKI resistance EGFR T790M mutation",
    #              :current_patients => 6,
    #              :former_patients => 1 ,
    #              :not_enrolled_patients => 0 ,
    #              :pending_patients => 2 ,
    #              :treatment_arm_status => "OPEN" ,
    #              :date_created => "2016-03-03T19:38:37.890Z" ,
    #              :date_opened =>"2016-03-03T19:38:37.890Z" ,
    #              :date_closed => "2016-03-03T19:38:37.890Z" ,
    #              :date_suspended=> "2016-03-03T19:38:37.890Z"
    # end

    it "recieved from db" do
      basic_treatment_arm.configure_client(client: stub_client)
      expect(basic_treatment_arm.treatment_arm_id).to eq("EAY131-A")
      expect(basic_treatment_arm.description).to eq("TestDescription")
      expect(basic_treatment_arm.treatment_arm_status).to eq("OPEN")
      expect(basic_treatment_arm.date_created).to eq("2016-01-11")
      expect(basic_treatment_arm.date_opened).to eq("2016-03-20")

      expect(basic_treatment_arm.current_patients).to eq(0)
      expect(basic_treatment_arm.former_patients).to eq(3)
      expect(basic_treatment_arm.not_enrolled_patients).to eq(2)
      expect(basic_treatment_arm.pending_patients).to eq(1)

    end
  end

end