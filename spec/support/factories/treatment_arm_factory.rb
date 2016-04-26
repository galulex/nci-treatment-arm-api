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
    target_id "750691"
    target_name "Afatinib"
    gene "EGFR"
    exclusion_criterias []
    pten_results []
    num_patients_assigned 2
    max_patients_allowed 35
    treatment_arm_status "OPEN"
    date_created "2016-03-03T19:38:37.890Z"
  end

  factory :patient_disease_graph, :class => DiseasePieData do
    _id "EAY131-A"
    disease_array [{
                       :label => "Prostate Cancer",
                       :data => 2,
                       :psns => ["232re", "289re"]
                   }]
  end

  factory :patient_status_graph, :class => StatusPieData do
    _id "EAY131-B"
    status_array [{
                      :label => "Cancer",
                      :data => 5,
                      :psns => ["215re", "216re"]
                  }]
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