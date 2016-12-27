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

  treatment_arm_assignment = FactoryGirl.build(:treatment_arm_assignment_event)

  it 'has a valid factory' do
    expect(treatment_arm_assignment).to be_truthy
  end

  it 'should be the correct class type for the variables' do
    stub_client.stub_responses(:describe_table, table: { table_status: 'ACTIVE' })
    treatment_arm_assignment.configure_client(client: stub_client)
    expect(treatment_arm_assignment.treatment_arm_id).to be_kind_of(String)
    expect(treatment_arm_assignment.assignment_date).to be_kind_of(Date)
    expect(treatment_arm_assignment.date_off_arm).to be_kind_of(Date)
    expect(treatment_arm_assignment.date_on_arm).to be_kind_of(Date)
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

  it 'should be of the correct instance' do
    treatment_arm_assignment = TreatmentArmAssignmentEvent.new()
    expect(treatment_arm_assignment).to be_an_instance_of(TreatmentArmAssignmentEvent)
  end

  it 'automatically declares patient_id' do
    expect{treatment_arm_assignment.patient_id}.to_not raise_error
  end

  it "should be valid when an instance is created" do
    expect(TreatmentArmAssignmentEvent.new).to be_truthy
  end

  it 'should be valid with valid attributes' do
    treatment_arm_assignment = TreatmentArmAssignmentEvent.new(patient_id: '200re', treatment_arm_id: 'APEC1621-A', assignment_date: '2012-02-20')
    expect(treatment_arm_assignment).to be_truthy
  end

  it 'should generate unique date_created field' do
    TreatmentArmAssignmentEvent.stub(:first).and_return(nil)
    assignment_date = DateTime.current.getutc.to_s
    expect(assignment_date).to be_truthy
  end

  it 'should generate different unique assignment_date fields' do
    TreatmentArmAssignmentEvent.stub(:first).and_return(nil)
    assignment_date1 = DateTime.current.getutc.to_s
    sleep(1)
    assignment_date2 = DateTime.current.getutc.to_s
    expect(assignment_date1).not_to eq(assignment_date2)
  end

  describe 'Attributes' do
    let(:record) do
      Class.new do
        include(Aws::Record)
      end
    end

    describe '#initialize' do
      let(:model) do
        Class.new do
          include(Aws::Record)
          string_attr(:patient_id, hash_key: true)
          string_attr(:treatment_arm_id)
          string_attr(:assignment_date)
        end
      end

      it 'should allow attribute assignment at item creation time' do
        item = model.new(patient_id: '3366')
        expect(item.patient_id).to eq('3366')
        expect(item.treatment_arm_id).to be_nil
      end

      it 'should allow assignment of multiple attributes at item creation' do
        item = model.new(patient_id: '3366', treatment_arm_id: 'APEC1621-A', assignment_date: '2015-08-06')
        expect(item.treatment_arm_id).to eq('APEC1621-A')
        expect(item.patient_id).to eq('3366')
        expect(item.assignment_date).to eq('2015-08-06')
      end
    end

    describe 'Keys' do
      it 'should be able to assign a hash key' do
        record.string_attr(:patient_id, hash_key: true)
        expect(record.hash_key).to eq(:patient_id)
      end

      it 'should be able to assign a hash and range key' do
        record.string_attr(:patient_id, hash_key: true)
        record.string_attr(:assignment_date, range_key: true)
        expect(record.hash_key).to eq(:patient_id)
        expect(record.range_key).to eq(:assignment_date)
      end

      it 'should reject assigning the same attribute as hash and range key' do
        expect { record.string_attr(:patient_id, hash_key: true, range_key: true) }.to raise_error(ArgumentError)
      end
    end

    describe 'Attributes' do
      it 'should create dynamic methods around attributes' do
        record.string_attr(:assignment_reason)
        x = record.new
        x.assignment_reason = ''
        expect(x.assignment_reason).to eq('')
      end

      it 'should reject non-symbolized attribute names' do
        expect { record.integer_attr('integer') }.to raise_error(ArgumentError)
      end

      it 'should not allow duplicate assignment of the same attr name' do
        record.string_attr(:patient_status)
        expect { record.datetime_attr(:patient_status) }.to raise_error(Aws::Record::Errors::NameCollision)
      end

      it 'should typecast an integer attribute' do
        record.integer_attr(:step_number)
        x = record.new
        x.step_number = '5'
        expect(x.step_number).to eq(5)
      end

      it 'should not allow collisions with reserved names' do
        expect { record.string_attr(:to_h) }.to raise_error(Aws::Record::Errors::ReservedName)
      end
    end
  end
end
