require 'rails_helper'
require 'factory_girl_rails'

describe Api::V1::TreatmentArmsController do
  before(:each) do
    setup_knock
  end

  let(:treatment_arm) do
    stub_model TreatmentArm,
               treatment_arm_id: 'APEC1621-A',
               version: '2016-20-02',
               stratum_id: '12',
               description: 'This is the sample Description',
               target_id: 'HDFD',
               target_name: 'OtherHen',
               gene: 'GENE',
               treatment_arm_drugs:
               [
                 {
                   'drug_id': '113',
                   'name': 'a'
                 }
               ],
               snv_indels:
                 [
                   {
                     'position': '30035190',
                     'ocp_alternative': '-',
                     'gene': 'NRAS',
                     'protein': 'p.Q61H',
                     'level_of_evidence': '3.0',
                     'ocp_reference': 'TTC',
                     'variant_type': 'snp',
                     'chromosome': 'chr22',
                     'arm_specific': false,
                     'identifier': 'COSM22189',
                     'public_med_ids':
                     [
                       '18827604',
                       '21917678',
                       '23181703'
                     ],
                     'inclusion': true
                    }
                  ],
               diseases:
                 [
                   {
                     'disease_code': '8200/0',
                     'disease_code_type': 'ICD-O',
                     'exclusion': false,
                     'disease_name': 'Eccrine dermal cylindroma (C44._)\nTurban tumor (C44.4)\nCylindroma of skin (C44._)'
                   }
                 ],
               exclusion_drugs: []
  end

  describe 'POST #treatment_arm' do
    context 'with valid data' do
      it 'should route to the correct controller' do
        expect(post: 'api/v1/treatment_arms/APEC1621-A/100/2016-10-07').to route_to(controller: 'api/v1/treatment_arms', action: 'create',
               treatment_arm_id: 'APEC1621-A', stratum_id: '100', version: '2016-10-07')
      end

      it 'should save data to the database' do
        allow(Aws::Publisher).to receive(:publish).and_return('')
        allow(JSON::Validator).to receive(:validate).and_return(true)
        params = { treatment_arm_id: 'APEC1621-A', stratum_id: '100', version: '2017-10-07' }
        post :create, params.to_json, params.merge(format: 'json')
        expect(response).to have_http_status(200)
      end

      it 'should respond with a success json message' do
        allow(Aws::Publisher).to receive(:publish).and_return('')
        allow(JSON::Validator).to receive(:validate).and_return(true)
        params = { treatment_arm_id: 'APEC1621-A', stratum_id: '100', version: '2017-10-07' }
        post :create, params.to_json, params.merge(format: 'json')
        expect(response.body).to include('Message has been processed successfully')
        expect(response).to have_http_status(200)
      end

      it 'should raise the UrlGenerationError' do
        allow(TreatmentArm).to receive(:scan).and_raise('this error')
        expect { post :create, treatment_arm_id: 'APEC1621-A' }.to raise_error(ActionController::UrlGenerationError)
      end
    end

    context 'With Invalid Data' do
      it 'should respond with a failure json message' do
        allow(Aws::Publisher).to receive(:publish).and_return('')
        allow(JSON::Validator).to receive(:validate).and_return(false)
        params = { treatment_arm_id: 'null', stratum_id: '100', version: '2017-10-07' }
        post :create, params.to_json, params.merge(format: 'json')
        expect(response.body).to include("The property '#/' did not contain a required property of 'name'")
        expect(response).to have_http_status(500)
      end
    end
  end

  describe 'GET #treatment_arms' do

    it 'should route to the correct controller' do
      expect(get: 'api/v1/treatment_arms').to route_to(controller: 'api/v1/treatment_arms', action: 'index')
      expect(get: 'api/v1/treatment_arms/APEC1621-A/100').to route_to(controller: 'api/v1/treatment_arms', action: 'index',
             treatment_arm_id: 'APEC1621-A', stratum_id: '100')
    end

    it 'should retrieve a specific treatment arm' do
      expect(get: 'api/v1/treatment_arms/APEC1621-A/100/2016-10-07').to route_to(controller: 'api/v1/treatment_arms', action: 'show',
             treatment_arm_id: 'APEC1621-A', stratum_id: '100', version: '2016-10-07')
    end

    it 'should return list of all treatment arms' do
      allow(TreatmentArm).to receive(:scan).and_return([treatment_arm])
      get :index, format: :json
      expect(response).to have_http_status(200)
      expect { JSON.parse(response.body) }.to_not raise_error
      expect(response).to_not be_nil
    end

    it 'should return an empty array when there are no TAs in the DB' do
      allow(TreatmentArm).to receive(:scan).and_return([])
      get :index, treatment_arm_id: 'EAY131-A', stratum_id: '200'
      expect(response.body).to eq("[]")
      expect(response).to have_http_status(200)
    end

    it 'should return all treatmentArms with id and stratum_id' do
      allow(TreatmentArm).to receive(:scan).and_return([treatment_arm])
      get :index, treatment_arm_id: 'APEC1621-A', stratum_id: '12'
      expect(response).to_not be_nil
      expect(response).to have_http_status(200)
      expect { JSON.parse(response.body) }.to_not raise_error
    end

    it 'should return all treatmentArms with id, stratum_id, version' do
      allow(TreatmentArm).to receive(:scan).and_return([treatment_arm])
      get :index, treatment_arm_id: 'APEC1621-A', stratum_id: '12', version: '2016-20-02'
      expect(response).to_not be_nil
      expect(response).to have_http_status(200)
    end

    it 'should return 404 Not Found for a TA that is not present in the DB' do
      allow(TreatmentArm).to receive(:scan).and_return([])
      get :show, treatment_arm_id: 'APEC1621', stratum_id: '11', version: '2016-20-05'
      expect(response).to_not be_nil
      expect(response).to have_http_status(404)
    end

    it 'should respond with a Resource Not Found message' do
      allow(TreatmentArm).to receive(:scan).and_return([])
      get :show, treatment_arm_id: 'APEC1621-A', stratum_id: '11', version: '2016-20-05'
      expect(response.body).to include('Resource Not Found')
    end

    it 'should raise the UrlGenerationError' do
      allow(TreatmentArm).to receive(:scan).and_raise('this error')
      expect { get :show, treatment_arm_id: 'APEC1621-A' }.to raise_error(ActionController::UrlGenerationError)
    end
  end

  describe 'POST #PatientAssignment' do
    context 'with valid data' do
      it 'should route to the correct controller' do
        expect(post: 'api/v1/treatment_arms/APEC1621-A/100/2016-10-07/assignment_event').to route_to(controller: 'api/v1/treatment_arms', action: 'assignment_event',
               treatment_arm_id: 'APEC1621-A', stratum_id: '100', version: '2016-10-07')
      end

      it 'should save data to the DataBase' do
        params = { treatment_arm_id: 'APEC1621-A', stratum_id: '100', version: '2017-10-07' }
        post :assignment_event, params.to_json, params.merge(format: 'json')
        expect(response).to_not be_nil
        expect(response).to have_http_status(200)
      end

      it 'should not raise error on successful assignment of the patient' do
        params = { treatment_arm_id: 'APEC1621-A', stratum_id: '100', version: '2016-20-02' }
        post :assignment_event, params.to_json, params.merge(format: 'json')
        expect { JSON.parse(response.body) }.to_not raise_error
      end

      it 'should raise the UrlGenerationError' do
        allow(TreatmentArmAssignmentEvent).to receive(:scan).and_raise('this error')
        expect { post :assignment_event, treatment_arm_id: 'APEC1621-A' }.to raise_error(ActionController::UrlGenerationError)
      end
    end
  end

  describe 'GET #AssignmentReport' do
    it 'should route to the correct controller' do
      expect(get: 'api/v1/treatment_arms/APEC1621-A/100/assignment_report').to route_to(controller: 'api/v1/treatment_arms', action: 'patients_on_treatment_arm',
             treatment_arm_id: 'APEC1621-A', stratum_id: '100')
    end

    it 'should return an empty array if TA id & stratum_id are not present in the DB' do
      allow(TreatmentArmAssignmentEvent).to receive(:scan).and_return([])
      get :patients_on_treatment_arm, treatment_arm_id: 'EAY131-A', stratum_id: '200'
      expect(response.body).to eq("[]")
      expect(response).to have_http_status(200)
    end

    it 'should display the patient list and the statistics of that patient' do
      allow(TreatmentArmAssignmentEvent).to receive(:scan).and_return([treatment_arm])
      get :patients_on_treatment_arm, treatment_arm_id: 'APEC1621-A', stratum_id: '100'
      expect(response).to_not be_nil
      expect { JSON.parse(response.body) }.to_not raise_error
    end

    it 'should raise the UrlGenerationError' do
      allow(TreatmentArmAssignmentEvent).to receive(:scan).and_raise('this error')
      expect { get :patients_on_treatment_arm, treatment_arm_id: 'APEC1621-A' }.to raise_error(ActionController::UrlGenerationError)
    end

    it 'should handle errors correctly' do
      allow(TreatmentArmAssignmentEvent).to receive(:scan).and_raise('this error')
      get :patients_on_treatment_arm, treatment_arm_id: 'APEC1621-A', stratum_id: '100'
      expect(response).to have_http_status(500)
    end
  end
end
