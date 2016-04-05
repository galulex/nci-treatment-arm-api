# require 'factory_girl'

FactoryGirl.define do
  factory :treatmentArm, :class => TreatmentArm do
    _id "EAY131-test"
  end

  factory :treatmentArmVersions, :class => TreatmentArm do
    _id "EAY131-test-Version"
    version Time.now
  end

  factory :basic_treatment_arm, :class => TreatmentArm do
          _id "EAY131-A"
          name "Afatinib in EGFR activating"
          version "2016-02-20"
          description "Afatinib in EGFR activating mutation"
          targetId "750691"
          targetName "Afatinib"
          gene "EGFR"
          exclusionCriterias []
          ptenResults []
          numPatientsAssigned 2
          maxPatientsAllowed 35
          treatmentArmStatus "OPEN"
          dateCreated "2016-03-03T19:38:37.890Z"

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