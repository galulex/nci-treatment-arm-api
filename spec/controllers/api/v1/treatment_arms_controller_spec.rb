require 'rails_helper'
require 'factory_girl_rails'
require 'aws-record'

describe Api::V1::TreatmentArmsController do
  before(:each) do
    setup_knock
    @request.headers['Content-Type'] = 'application/json'
  end

  treatment_arm = FactoryGirl.build(:treatment_arm)
  treatment_arm_with_trailing_spaces = FactoryGirl.build(:treatment_arm_with_trailing_spaces)
  treatment_arm_without_trailing_spaces = FactoryGirl.build(:treatment_arm_without_trailing_spaces)

  it 'should have a valid TreatmentArm factory' do
    expect(treatment_arm).to be_truthy
  end

  describe 'POST #treatment_arm' do
    context 'with valid data' do
      it 'should route to the correct controller' do
        expect(post: 'api/v1/treatment_arms/APEC1621-A/100/2016-10-07').to route_to(controller: 'api/v1/treatment_arms', action: 'create',
                                                                                    treatment_arm_id: 'APEC1621-A', stratum_id: '100', version: '2016-10-07')
      end

      it 'should include Aws::Record gem from the model' do
        expect(TreatmentArm.include?(Aws::Record)).to be_truthy
      end

      it 'should handle errors correctly' do
        allow_any_instance_of(Api::V1::TreatmentArmsController).to receive(:update).and_raise(status: 500)
        post :create, params: { treatment_arm_id: treatment_arm.treatment_arm_id, stratum_id: treatment_arm.stratum_id, version: treatment_arm.version }
        expect(response).to have_http_status(500)
      end

      it 'should put a TreatmentArm onto the queue' do
        allow(Aws::Publisher).to receive(:publish).and_return('')
        allow(JSON::Validator).to receive(:validate).and_return(true)
        post :create, params: { treatment_arm_id: treatment_arm.treatment_arm_id, stratum_id: treatment_arm.stratum_id, version: treatment_arm.version }
        expect(response).to have_http_status(202)
      end

      it 'should respond with a success json message' do
        allow(Aws::Publisher).to receive(:publish).and_return('')
        allow(JSON::Validator).to receive(:validate).and_return(true)
        post :create, params: { treatment_arm_id: treatment_arm.treatment_arm_id, stratum_id: treatment_arm.stratum_id, version: treatment_arm.version }
        expect(response.body).to include('Message has been processed successfully')
        expect(response).to have_http_status(202)
      end

      it 'should raise the UrlGenerationError' do
        allow(TreatmentArm).to receive(:scan).and_raise('this error')
        expect { post :create, treatment_arm_id: 'APEC1621-A' }.to raise_error(ActionController::UrlGenerationError)
      end

      it 'should remove the trailing spaces in the JSON' do
        expect(TreatmentArm.remove_trailing_spaces(treatment_arm_with_trailing_spaces.to_h)).to eq(treatment_arm_without_trailing_spaces.to_h)
      end

      it 'should throw Bad Request(400) when the same post request is hit with the same parameters' do
        allow(TreatmentArm).to receive(:find_by).and_return(treatment_arm)
        expect(treatment_arm).to_not be_nil
        post :create, treatment_arm_id: 'APEC1621-A', stratum_id: '12', version: 'v1', name: 'EAY131-test',
                      treatment_arm_drugs: treatment_arm.treatment_arm_drugs, study_id: treatment_arm.study_id, date_created: treatment_arm.date_created
        expect(response.body).to include('message')
        expect(response).to have_http_status(400)
      end
    end

    context 'With Invalid Data' do
      it 'should respond with a failure json message' do
        allow(Aws::Publisher).to receive(:publish).and_return('')
        allow(JSON::Validator).to receive(:validate).and_return(false)
        post :create, params: { treatment_arm_id: 'null', stratum_id: treatment_arm.stratum_id, version: treatment_arm.version }
        expect(response.body).to include("The property '#/' did not contain a required property of 'name'")
        expect(response).to have_http_status(412)
      end
    end
  end

  describe 'Error Handling' do
    context 'POST#TreatmentArm' do
      it 'should handle malformed requests correctly' do
        expect(post: 'api/v1/treatment_arms/APEC1621-A/100').to route_to(controller: 'api/v1/errors', action: 'render_not_found',
                                                                         path: 'treatment_arms/APEC1621-A/100')
      end
    end

    context 'GET#TreatmentArm' do
      it 'should handle malformed requests correctly' do
        expect(get: 'api/v1/treatment_arms/APEC1621-A').to route_to(controller: 'api/v1/errors', action: 'render_not_found',
                                                                    path: 'treatment_arms/APEC1621-A')
      end
    end

    context 'POST#PatientAssignment' do
      it 'should handle malformed requests correctly' do
        expect(post: 'api/v1/treatment_arms/APEC1621-A/100/2015-08-06/12').to route_to(controller: 'api/v1/errors', action: 'render_not_found',
                                                                                       path: 'treatment_arms/APEC1621-A/100/2015-08-06/12')
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

    it 'should return something on the index call' do
      get :index, treatment_arm_id: 'APEC1621-A'
      expect(response).to have_http_status(200)
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
      expect(response.body).to eq('[]')
      expect(response).to have_http_status(200)
    end

    it 'should return all treatmentArms with id and stratum_id' do
      allow(TreatmentArm).to receive(:scan).and_return([treatment_arm])
      get :index, treatment_arm_id: 'APEC1621-A', stratum_id: '12'
      expect(response).to_not be_nil
      expect(response).to have_http_status(200)
      expect { JSON.parse(response.body) }.to_not raise_error
    end

    it "should return empty array when there are no TA's with id & stratum_id" do
      allow(TreatmentArm).to receive(:scan).and_return([])
      get :index, treatment_arm_id: 'random', stratum_id: 'random'
      expect(response).to have_http_status(200)
      expect(response.body).to eq('[]')
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

    it 'should handle errors correctly on index call' do
      allow(TreatmentArm).to receive(:scan).and_return(treatment_arm)
      get :index, treatment_arm_id: 'APEC1621-A', stratum_id: '100', version: 'v1'
      expect(response).to have_http_status(500)
    end

    it 'should handle errors correctly' do
      allow_any_instance_of(Api::V1::TreatmentArmsController).to receive(:check_params).and_raise(status: 500)
      get :index, format: :json
      expect(response).to have_http_status(500)
    end

    it 'should handle errors correctly' do
      allow_any_instance_of(Api::V1::TreatmentArmsController).to receive(:check_params).and_raise(status: 500)
      get :show, treatment_arm_id: 'APEC1621-A', stratum_id: '100', version: '2015-08-06'
      expect(response).to have_http_status(500)
    end

    it 'should handle errors correctly on show call' do
      allow(TreatmentArm).to receive(:scan).and_return(treatment_arm)
      get :show, treatment_arm_id: 'APEC1621-A', stratum_id: '100', version: 'v1', name: 'sample'
      expect(response).to have_http_status(500)
    end

    it 'should return a proper json with data' do
      treatment_arm = TreatmentArm.new
      treatment_arm.treatment_arm_id = 'APEC1621-A'
      treatment_arm.stratum_id = '12'
      treatment_arm.version = '2016-20-02'
      treatment_arm.date_created = DateTime.current.getutc.to_s
      allow(TreatmentArm).to receive(:scan).and_return([treatment_arm])
    end

    it 'should give all the active treatmentArms when active(true) parameter is passed' do
      get :index, active: true
      expect(response).to have_http_status(200)
      allow(TreatmentArm).to receive(:scan).and_return([treatment_arm])
    end

    it 'should give all the active treatmentArms when active(false) parameter is passed' do
      get :index, active: false
      expect(response).to have_http_status(200)
      allow(TreatmentArm).to receive(:scan).and_return([])
    end
  end

  describe 'POST #PatientAssignment' do
    context 'with valid data' do
      it 'should route to the correct controller' do
        expect(post: 'api/v1/treatment_arms/APEC1621-A/100/2016-10-07/assignment_event').to route_to(controller: 'api/v1/treatment_arms', action: 'assignment_event',
                                                                                                     treatment_arm_id: 'APEC1621-A', stratum_id: '100', version: '2016-10-07')
      end

      it 'should save data to the DataBase' do
        post :assignment_event, params: { treatment_arm_id: treatment_arm.treatment_arm_id, stratum_id: treatment_arm.stratum_id, version: treatment_arm.version }
        expect(response).to_not be_nil
        expect(response).to have_http_status(202)
      end

      it 'should not raise error on successful assignment of the patient' do
        post :assignment_event, params: { treatment_arm_id: treatment_arm.treatment_arm_id, stratum_id: treatment_arm.stratum_id, version: treatment_arm.version }
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
      expect(response.body).to eq('[]')
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

    it 'should assign patient status reason to assignment reason for some patient statuses' do
      allow(TreatmentArm).to receive(:scan).and_return(treatment_arm)

      treatment_arm_assignment1 = TreatmentArmAssignmentEvent.new
      treatment_arm_assignment1.treatment_arm_id_stratum_id = 'APEC1621-A_100'
      treatment_arm_assignment1.treatment_arm_id = 'APEC1621-A'
      treatment_arm_assignment1.stratum_id = '100'
      treatment_arm_assignment1.assignment_date = '2015-08-06'
      treatment_arm_assignment1.patient_status_reason = 'Doctor approved that he can never be on a TreatmentArm'
      treatment_arm_assignment1.assignment_reason = 'Blah Blah'
      treatment_arm_assignment1.patient_status = 'PREVIOUSLY_ON_ARM'
      allow(TreatmentArmAssignmentEvent).to receive(:scan).and_return([treatment_arm_assignment1])
      allow(TreatmentArmAssignmentEvent).to receive(:save).and_return(true)

      treatment_arm_assignment2 = TreatmentArmAssignmentEvent.new
      treatment_arm_assignment2.treatment_arm_id_stratum_id = 'APEC1621-A_100'
      treatment_arm_assignment1.treatment_arm_id = 'APEC1621-A'
      treatment_arm_assignment1.stratum_id = '100'
      treatment_arm_assignment2.assignment_date = '2015-08-07'
      treatment_arm_assignment2.patient_status_reason = 'Doctor approved that he can never be on a TreatmentArm'
      treatment_arm_assignment2.assignment_reason = 'Blah Blah'
      treatment_arm_assignment2.patient_status = 'NOT_ENROLLED_ON_ARM'
      allow(TreatmentArmAssignmentEvent).to receive(:scan).and_return([treatment_arm_assignment2])
      allow(TreatmentArmAssignmentEvent).to receive(:save).and_return(true)

      allow(TreatmentArmAssignmentEvent).to receive(:find_by).and_return([treatment_arm_assignment1, treatment_arm_assignment2])

      TreatmentArmAssignmentEvent.find_with_variant_stats('APEC1621-A', '100', 'OPEN')

      expect(treatment_arm_assignment1.assignment_reason).to eq(treatment_arm_assignment1.patient_status_reason)
      expect(treatment_arm_assignment2.assignment_reason).to eq(treatment_arm_assignment2.patient_status_reason)

      get :patients_on_treatment_arm, treatment_arm_id: treatment_arm_assignment1.treatment_arm_id, stratum_id: treatment_arm_assignment1.stratum_id
      expect(response).to have_http_status(200)
      expect{ JSON.parse(response.body) }.to_not raise_error
      expect(response.body).to_not be_nil
      expect(response.body).to include('patients_list')
      expect(response.body).to be_kind_of(String)
    end
  end

  describe 'PUT #Cog_status' do
    it 'should route to the correct controller action' do
      expect(put: 'api/v1/treatment_arms/status').to route_to(controller: 'api/v1/treatment_arms', action: 'refresh')
    end

    it 'should get the latest treatmentArm status from COG' do
      allow(TreatmentArm).to receive(:scan).and_return([treatment_arm])
      put :refresh
      expect(response).to have_http_status(200)
      expect(response).to_not be_nil
    end

    it 'should get the latest treatmentArm status from Mock COG if COG is down on UAT' do
      Rails.env = 'uat'
      allow(TreatmentArm).to receive(:scan).and_return([treatment_arm])
      put :refresh
      expect(response).to have_http_status(500)
      expect(response).to_not be_nil
    end
  end

  describe 'GET #Projections' do
    it 'should display only the projection parameters' do
      get :index, 'projection' => ['exclusion_drugs']
      expect(response).to have_http_status(200)
      allow(TreatmentArm).to receive(:scan).and_return([])
    end

    it 'should display only the projection parameters & with non empty attribute parameters' do
      get :index, 'projection' => ['exclusion_drugs'], 'attribute' => ['snv_indels']
      expect(response).to have_http_status(200)
      allow(TreatmentArm).to receive(:scan).and_return([])
    end

    it 'should return 404 for a Not Found TreatmentArm even when projection parameters are passed' do
      get :show, 'projection' => ['snv_indels'], treatment_arm_id: treatment_arm.treatment_arm_id, stratum_id: treatment_arm.stratum_id, version: treatment_arm.version
      expect(response).to have_http_status(404)
      allow(TreatmentArm).to receive(:scan).and_return([])
    end

    it 'should display only the projection parameters on a specific TreatmentArm' do
      get :show, 'projection' => ['snv_indels'], treatment_arm_id: 'APEC1621-A', stratum_id: '100', version: '2015-08-06'
      expect(response).to have_http_status(200)
      allow(TreatmentArm).to receive(:scan).and_return([])
    end

    it 'should display only the projection parameters & with non empty attribute parameters on a specific TreatmentArm' do
      get :show, 'projection' => ['snv_indels'], 'attribute' => ['diseases'], treatment_arm_id: 'APEC1621-A', stratum_id: '100', version: '2015-08-06'
      expect(response).to have_http_status(200)
      allow(TreatmentArm).to receive(:scan).and_return([])
    end
  end

  describe 'MockCogService' do
    it "Should call Mock COG when the actual COG is down or wan't able to connect" do
      allow(HTTParty::Request).to receive(:new).and_return(HTTParty::Request)
      allow(HTTParty::Response).to receive(:new).and_return(HTTParty::Response)
      allow(HTTParty::Request).to receive(:perform).and_return(HTTParty::Response)
      allow(HTTParty::Response).to receive(:code).and_return(200)
      expect(MockCogService.perform(treatment_arm)).to be_truthy
    end

    it 'should raise exception when unable to connect to Mock COG' do
      allow(HTTParty::Request).to receive(:new).and_return(HTTParty::Request)
      allow(HTTParty::Response).to receive(:new).and_return(HTTParty::Response)
      allow(HTTParty::Request).to receive(:perform).and_return(HTTParty::Response)
      allow(HTTParty::Response).to receive(:code).and_return(500)
      allow(MockCogService.perform(treatment_arm)).to receive(:scan).and_raise('this error')
    end
  end
end
