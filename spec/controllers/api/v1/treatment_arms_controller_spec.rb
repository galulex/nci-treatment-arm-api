require 'rails_helper'
require 'factory_girl_rails'

describe Api::V1::TreatmentArmsController do
  before(:each) do
    setup_knock
  end

  let(:basic_treatment_arm) do
    stub_model TreatmentArm,
                 id: '',
                 name: '',
                 stratum_id: '',
                 treatment_arm_status: 'PENDING',
                 date_opened: '',
                 date_closed: '',
                 current_patients: 0,
                 former_patients: 1,
                 not_enrolled_patients: 2,
                 pending_patients: 0
  end

  let(:treatment_arm) do
    stub_model TreatmentArm,
                 id: 'APEC1621-A',
                 version: '2016-20-02',
                 stratum_id: '12',
                 description: 'WhoKnows',
                 target_id: 'HDFD',
                 target_name: 'OtherHen',
                 gene: 'GENE',
                 treatment_arm_status: 'PENDING',
                 num_patients_assigned: 4,
                 date_created: '2016-03-03T19:38:37.890Z',
                 treatment_arm_drugs: [],
                 snv_indels: [],
                 diseases: [],
                 exclusion_drugs: [],
                 status_log: []
  end

  describe 'POST #treatment_arm' do
    context 'with valid data' do
      it 'Should route to the correct controller' do
        expect(post: 'api/v1/treatment_arms/EAY131-A/100/2016-10-07').to route_to(controller: 'api/v1/treatment_arms', action: 'create',
                 id: 'EAY131-A', stratum_id: '100', version: '2016-10-07')
      end

      it 'should save data to the database' do
        allow(Aws::Publisher).to receive(:publish).and_return('')
        allow(JSON::Validator).to receive(:validate).and_return(true)
        params = { id: 'EAY131-A', stratum_id: '100', version: '2017-10-07' }
        post :create, params.to_json, params.merge(format: 'json')
        expect(response).to have_http_status(200)
      end

      it 'should respond with a success json message' do
        allow(Aws::Publisher).to receive(:publish).and_return('')
        allow(JSON::Validator).to receive(:validate).and_return(true)
        params = { id: 'EAY131-A', stratum_id: '100', version: '2017-10-07' }
        post :create, params.to_json, params.merge(format: 'json')
        expect(response.body).to include('Message has been processed successfully')
        expect(response).to have_http_status(200)
      end
    end

    context 'With Invalid Data' do
      it 'should respond with a failure json message' do
        allow(Aws::Publisher).to receive(:publish).and_return('')
        allow(JSON::Validator).to receive(:validate).and_return(false)
        params = { id: 'null', stratum_id: '100', version: '2017-10-07' }
        post :create, params.to_json, params.merge(format: 'json')
        expect(response.body).to include("The property '#/' did not contain a required property of 'name'")
        expect(response).to have_http_status(500)
      end
    end
  end

  describe 'GET #treatment_arms' do

    it 'should route to the correct controller' do
      expect(get: 'api/v1/treatment_arms').to route_to(controller: 'api/v1/treatment_arms', action: 'index')
      expect(get: 'api/v1/treatment_arms/EAY131-A/100').to route_to(controller: 'api/v1/treatment_arms', action: 'index',
             id: 'EAY131-A', stratum_id: '100')
    end

    it 'should retrieve a specific treatment_arm' do
      expect(get: 'api/v1/treatment_arms/EAY131-A/100/2016-10-07').to route_to(controller: 'api/v1/treatment_arms', action: 'show',
             id: 'EAY131-A', stratum_id: '100', version: '2016-10-07')
    end

    it 'should handle errors correctly' do
      allow(TreatmentArm).to receive(:scan).and_raise('this error')
      get :index
      expect(response).to have_http_status(200)
    end

    it 'should return all treatment_arms if nothing is given' do
      allow(TreatmentArm).to receive(:scan).and_return([treatment_arm])
      get :index, format: :json
      expect(response).to_not be_nil
      expect(response).to have_http_status(200)
    end

    it 'should return all treatmentArms with id and stratum_id' do
      allow(TreatmentArm).to receive(:scan).and_return([treatment_arm])
      get :index, id: 'APEC1621-A', stratum_id: '12'
      expect(response).to_not be_nil
      expect(response).to have_http_status(200)
    end

    it 'should return all treatmentArms with id, stratum_id, version' do
      allow(TreatmentArm).to receive(:scan).and_return([treatment_arm])
      get :index, id: 'EAY131-A', stratum_id: '12', version: '2016-20-02'
      expect(response).to_not be_nil
      expect(response).to have_http_status(200)
    end

    it 'should return 404 Not Found for a TA that is not present in the DB' do
      allow(TreatmentArm).to receive(:scan).and_return([treatment_arm])
      get :show, id: 'EAY131-A', stratum_id: '11', version: '2016-20-05'
      expect(response).to_not be_nil
      expect(response).to have_http_status(404)
    end

    it 'should respond with a Resource Not Found message' do
      allow(TreatmentArm).to receive(:scan).and_return([treatment_arm])
      get :show, id: 'EAY131-A', stratum_id: '11', version: '2016-20-05'
      expect(response.body).to include("Resource Not Found")
    end
  end

  describe 'POST #PatientAssignment' do
    context 'with valid data' do
      it 'Should route to the correct controller' do
        expect(post: 'api/v1/treatment_arms/EAY131-A/100/2016-10-07/assignment_event').to route_to(controller: 'api/v1/treatment_arms', action: 'assignment_event',
               id: 'EAY131-A', stratum_id: '100', version: '2016-10-07')
      end

      it 'Should save data to the DataBase' do
        params = { id: 'EAY131-A', stratum_id: '100', version: '2017-10-07' }
        post :assignment_event, params.to_json, params.merge(format: 'json')
        expect(response).to_not be_nil
        expect(response).to have_http_status(200)
      end
    end
  end
end
