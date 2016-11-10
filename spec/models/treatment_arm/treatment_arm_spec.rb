require 'spec_helper'

describe TreatmentArm do

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

  treatment_arm = FactoryGirl.build(:treatment_arm)

  it 'has a valid factory' do
    expect(treatment_arm).to be_truthy
  end

  it 'should be the correct class type for the variables' do
    stub_client.stub_responses(:describe_table,
                                {
                                  table: { table_status: 'ACTIVE' }
                                }
                              )
    treatment_arm.configure_client(client: stub_client)
    expect(treatment_arm.name).to be_kind_of(String)
    expect(treatment_arm.treatment_arm_id).to be_kind_of(String)
    expect(treatment_arm.version).to be_kind_of(String)
    expect(treatment_arm.description).to be_kind_of(String)
    expect(treatment_arm.target_id).to be_kind_of(String)
    expect(treatment_arm.target_name).to be_kind_of(String)
    expect(treatment_arm.gene).to be_kind_of(String)
    expect(treatment_arm.treatment_arm_status).to be_kind_of(String)
    expect(treatment_arm.num_patients_assigned).to be_kind_of(Integer)
    expect(treatment_arm.treatment_arm_id).to be_kind_of(String)
    expect(treatment_arm.study_id).to be_kind_of(String)
    expect(treatment_arm.stratum_id).to be_kind_of(String)
    expect(treatment_arm.assay_rules).to be_kind_of(Array)
    expect(treatment_arm.treatment_arm_drugs).to be_kind_of(Array)
    expect(treatment_arm.diseases).to be_kind_of(Array)
    expect(treatment_arm.exclusion_drugs).to be_kind_of(Array)
    expect(treatment_arm.gene_fusions).to be_kind_of(Array)
    expect(treatment_arm.snv_indels).to be_kind_of(Array)
    expect(treatment_arm.non_hotspot_rules).to be_kind_of(Array)
    expect(treatment_arm.copy_number_variants).to be_kind_of(Array)
    expect(treatment_arm.date_created).to be_kind_of(String)
    expect(treatment_arm.date_opened).to be_kind_of(String)
  end

  it 'should be the correc class type for the version and stratum statistics' do
    expect(treatment_arm.not_enrolled_patients).to be_kind_of(Integer)
    expect(treatment_arm.former_patients).to be_kind_of(Integer)
    expect(treatment_arm.pending_patients).to be_kind_of(Integer)
    expect(treatment_arm.current_patients).to be_kind_of(Integer)
    expect(treatment_arm.version_pending_patients).to be_kind_of(Integer)
    expect(treatment_arm.version_former_patients).to be_kind_of(Integer)
    expect(treatment_arm.version_current_patients).to be_kind_of(Integer)
    expect(treatment_arm.version_not_enrolled_patients).to be_kind_of(Integer)
  end

  it 'should return the correct class type for the Boolean attribute' do
    expect(treatment_arm.active).to be_kind_of(TrueClass)
    treatment_arm.active = false
    expect(treatment_arm.active).to be_kind_of(FalseClass)
  end

  it 'automatically declares treatment_arm_id' do
    expect{treatment_arm.treatment_arm_id}.to_not raise_error
  end

  it "should be valid when an instance is created" do
    expect(TreatmentArm.new).to be_truthy
  end

  it 'should be valid with valid attributes' do
    treatment_arm = TreatmentArm.new(treatment_arm_id: 'APEC1621', stratum_id: 'EAY131', version: 'EAY13102')
    expect(treatment_arm).to be_truthy
  end

  it 'should be of the correct instance' do
    treatment_arm = TreatmentArm.new()
    expect(treatment_arm).to be_an_instance_of(TreatmentArm)
  end
end