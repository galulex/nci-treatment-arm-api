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
        match "*path", to: 'errors#render_not_found', via: :all
      end
    end
  end
end
