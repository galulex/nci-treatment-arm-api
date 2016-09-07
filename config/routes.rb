
Rails.application.routes.draw do
  controller :treatmentarm do
    namespace 'api' do
       namespace 'v1' do
         resources :treatment_arms, except: %w(new update edit create show) do
           member do
             post ':stratum_id/:version', to: 'treatment_arms#create'
             get ':stratum_id/:version', to: 'treatment_arms#show'
             get ':stratum_id', to: 'treatment_arms#index'
             put ':stratum_id/:version', to: 'treatment_arms#update_clone'
           end
           collection do
             get 'version', to: 'version#version', as: 'version'
             get 'ping', to: 'ping#ping', as: 'ping'
           end
         end
       end
     end
  end

  controller :patient do
    get 'patientsOnTreatmentArm/:id' => :patient_on_treatment_arm
    post 'patientAssignment' => :patient_assignment
    get 'patientReadyForAssignment' => :queue_treatment_arm_assignment
  end

  controller :graph_data do
    get 'patientStatusGraph' => :patient_status_count
    get 'patientStatusGraph/:id' => :patient_status_count
    get 'patientDiseaseGraph' => :patient_disease_data
    get 'patientDiseaseGraph/:id' => :patient_disease_data
  end
end