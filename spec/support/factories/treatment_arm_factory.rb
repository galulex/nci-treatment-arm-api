# require 'factory_girl'

FactoryGirl.define do
  factory :treatmentArm, :class => TreatmentArm do
    name "EAY131-test"
  end

  factory :treatmentArmVersions, :class => TreatmentArm do
    name "EAY131-test-Version"
    version Time.now
  end
end