require 'spec_helper'

describe TreatmentArmAssignmentEvent do
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

  let(:treatment_arm_assignment) do
    ba = TreatmentArmAssignmentEvent.new
    ba.date_generated = "2012-02-20"
    ba.patient_id = "200re"
    ba.treatment_arm_id = "EAC123"
    ba.stratum_id = "12"
    ba.patient_status = "PENDING"
    ba.assignment_reason = ""
    ba.diseases = [{ "drug_id" => "1234" }]
    ba.version = "2012-02-20"
    ba.step_number = "0"
    ba.analysis_id = "1"
    ba.molecular_id = "2"
    ba.surgical_event_id = "3"
    ba
  end

  it "should the correct class type for the variables" do
    stub_client.stub_responses(:describe_table, table: { table_status: 'ACTIVE' })
    treatment_arm_assignment.configure_client(client: stub_client)
    expect(treatment_arm_assignment.treatment_arm_id).to be_kind_of(String)
    expect(treatment_arm_assignment.patient_id).to be_kind_of(String)
    expect(treatment_arm_assignment.version).to be_kind_of(String)
    expect(treatment_arm_assignment.analysis_id).to be_kind_of(String)
    expect(treatment_arm_assignment.molecular_id).to be_kind_of(String)
    expect(treatment_arm_assignment.surgical_event_id).to be_kind_of(String)
    expect(treatment_arm_assignment.step_number).to be_kind_of(String)
    expect(treatment_arm_assignment.diseases).to be_kind_of(Array)
    expect(treatment_arm_assignment.assignment_reason).to be_kind_of(String)
    expect(treatment_arm_assignment.patient_status).to be_kind_of(String)
  end
end
