
FactoryGirl.define do

  factory :confirmable_variant, :class => ConfirmableVariant, parent: :non_Hotspot_Rule_faker do
    confirmed true
  end
end