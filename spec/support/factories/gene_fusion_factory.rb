
FactoryGirl.define do

  factory :gene_fusion_amoi, :class => GeneFusion, parent: :confirmable_variant do

    fusionIdentity "TMC"

  end

end