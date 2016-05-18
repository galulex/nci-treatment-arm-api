# require 'factory_girl'

FactoryGirl.define do
  factory :treatmentArm, :class => TreatmentArm do
    name "EAY131-test"
  end

  factory :treatmentArmVersions, :class => TreatmentArm do
    name "EAY131-test-Version"
    version Time.now
  end

  factory :basic_treatment_arm, :class => BasicTreatmentArm do
    treatment_arm_id "EAY131-A"
    treatment_arm_name "AZD9291 in TKI resistance EGFR T790M mutation"
    current_patients 6
    former_patients 1
    not_enrolled_patients 0
    pending_patients 2
    treatment_arm_status "OPEN"
    date_created "2016-03-03T19:38:37.890Z"
    date_opened "2016-03-03T19:38:37.890Z"
    date_closed "2016-03-03T19:38:37.890Z"
    date_suspended "2016-03-03T19:38:37.890Z"
  end

  factory :patient_disease_graph, :class => DiseasePieData do
    id "EAY131-A"
    disease_array [{
                       :label => "Prostate Cancer",
                       :data => 2,
                       :psns => ["232re", "289re"]
                   }]
  end

  factory :patient_status_graph, :class => StatusPieData do
    id "EAY131-B"
    status_array [{
                      :label => "Cancer",
                      :data => 5,
                      :psns => ["215re", "216re"]
                  }]
  end

end