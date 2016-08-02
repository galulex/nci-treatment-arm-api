
Rails.application.routes.draw do

  controller :treatmentarm do
    post 'newTreatmentArm' => :new_treatment_arm
    # post 'approveTreatmentArm' => :approve_treatment_arm
    # post 'ecogTreatmentArmList' => :ecog_treatment_arm_list


    get 'treatmentArm/:id' => :treatment_arm
    get 'treatmentArm/:id/:stratum_id' => :treatment_arm
    get 'treatmentArm/:id/:stratum_id/:version' => :treatment_arm

    get 'treatmentArms/:id' => :treatment_arms
    get 'treatmentArms/:id/:stratum_id' => :treatment_arms
    get 'treatmentArms' => :treatment_arms

    get 'treatmentArmVersions' => :treatment_arm_versions
    get 'basicTreatmentArms' => :basic_treatment_arms
    get 'basicTreatmentArms/:id' => :basic_treatment_arms
    get 'variantReport' => :variant_report
  end

  controller :version do
    get 'version' => :version
  end

  controller :patient do
    get 'patientsOnTreatmentArm/:id' => :patient_on_treatment_arm
    post 'patientAssignment' => :patient_assignment
    post 'patientReadyForAssignment' => :queue_treatment_arm_assignment
  end

  controller :graph_data do
    get 'patientStatusGraph' => :patient_status_count
    get 'patientStatusGraph/:id' => :patient_status_count
    get 'patientDiseaseGraph' => :patient_disease_data
    get 'patientDiseaseGraph/:id' => :patient_disease_data
  end

end