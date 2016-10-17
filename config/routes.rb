# Routing for TA
Rails.application.routes.draw do
  controller :treatmentarm do
    namespace 'api' do
      namespace 'v1' do
        resources :treatment_arms, except: %w(new update edit create show destroy) do
          collection do
            post ':treatment_arm_id/:stratum_id/:version/assignment_event', to: 'treatment_arms#assignment_event'
            post ':treatment_arm_id/:stratum_id/:version', to: 'treatment_arms#create'
            get ':treatment_arm_id/:stratum_id/assignment_report', to: 'treatment_arms#patients_on_treatment_arm'
            get ':treatment_arm_id/:stratum_id/:version', to: 'treatment_arms#show'
            get ':treatment_arm_id/:stratum_id', to: 'treatment_arms#index'
            put 'status', to: 'treatment_arms#refresh', as: 'refresh'
            get 'version', to: 'versions#version', as: 'version'
            get 'ping', to: 'ping#ping', as: 'ping'
          end
        end
      end
    end
  end

  controller :patient do
    namespace 'api' do
      namespace 'v1' do
        get 'patient_ready_for_assignment', to: 'patients#queue_treatment_arm_assignment'
      end
    end
  end

  controller :graph_data do
    get 'patientStatusGraph' => :patient_status_count
    get 'patientStatusGraph/:id' => :patient_status_count
    get 'patientDiseaseGraph' => :patient_disease_data
    get 'patientDiseaseGraph/:id' => :patient_disease_data
  end
end
