require 'rails_helper'
require 'factory_girl_rails'

describe Api::V1::PatientsController do

  before(:each) do
    setup_knock()
  end

  let(:patient_treatment_arm) do
    {
      assignment_date: '2012-02-20',
      date_on_arm: '2016-05-27',
      date_off_arm: '2013-01-19',
      patient_id: '200re',
      treatment_arm_id: 'EAC123',
      stratum_id: 'EAY131',
      patient_status: 'PENDING_CONFIRMATION',
      assignment_reason: '',
      diseases: [
        { 'drug_id': '1234' }
      ],
      version: '2012-02-20',
      step_number: '0',
      analysis_id: '1',
      molecular_id: '2',
      surgical_event_id: '3',
      variant_report: {},
      assignment_report: {},
      event: 'EVENT_INIT'
    }
  end

  describe 'GET #Patient for Assignment' do

    it 'should handle the routes correctly' do
      expect(get: '/api/v1/patient_ready_for_assignment').to route_to(controller: 'api/v1/errors', action: 'render_not_found', path: 'patient_ready_for_assignment')
    end

    it 'should return something on the index call' do
      get :queue_treatment_arm_assignment
      expect(response).to have_http_status(200)
    end

    it 'should not raise any error' do
      allow(TreatmentArmAssignmentEvent).to receive(:scan).and_return([patient_treatment_arm])
      get :queue_treatment_arm_assignment, format: :json
      expect(response).to have_http_status(200)
      expect { JSON.parse(response.body) }.to_not raise_error
      expect(response).to_not be_nil
    end

    it 'Should put the message on to the queue' do
      allow(Aws::Publisher).to receive(:publish).and_return('')
      get :queue_treatment_arm_assignment
      expect(response).to have_http_status(200)
    end
  end
end
