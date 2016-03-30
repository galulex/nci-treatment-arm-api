# require 'factory_girl'

FactoryGirl.define do
  factory :treatmentArm, :class => TreatmentArm do
    _id "EAY131-test"
  end

  factory :treatmentArmVersions, :class => TreatmentArm do
    _id "EAY131-test-Version"
    version Time.now
  end

  factory :amoiVariant, :class => VariantReport do
    singleNucleotideVariants {FactoryGirl.build(:single_nubleotide_variant_amoi)}
    indels {FactoryGirl.build(:indel_amoi)}
    copyNumberVariants {FactoryGirl.build(:copy_number_variant_amoi)}
    geneFusions {FactoryGirl.build(:gene_fusion_amoi)}
    unifiedGeneFusions {FactoryGirl.build(:unified_gene_fusion_amoi)}
    nonHotspotRules {FactoryGirl.build(:nonHotspotRulesAmoi)}

  end
end