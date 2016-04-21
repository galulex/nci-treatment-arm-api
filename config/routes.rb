
Rails.application.routes.draw do

  controller :treatmentarm do
    post 'newTreatmentArm' => :new_treatment_arm
    post 'approveTreatmentArm' => :approve_treatment_arm
    post 'ecogTreatmentArmList' => :ecog_treatment_arm_list


    get 'treatmentArms/:id' => :treatment_arm
    get 'treatmentArms/:id/:version' => :treatment_arm
    get 'treatmentArms' => :treatment_arms
    get 'treatmentArmVersions' => :treatment_arm_versions
    get 'basicTreatmentArms' => :basic_treatment_arms
    get 'basicTreatmentArm' => :basic_treatment_arm
    get 'variantReport' => :variant_report
  end

  controller :version do
    get 'version' => :version
  end

  controller :patient do

  end

end
