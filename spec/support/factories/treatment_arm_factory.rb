# require 'factory_girl'

FactoryGirl.define do
  factory :treatmentArm, :class => TreatmentArm do
    name "EAY131-test"
  end

  factory :treatmentArmVersions, :class => TreatmentArm do
    name "EAY131-test-Version"
    version Time.now
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