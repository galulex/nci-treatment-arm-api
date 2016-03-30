
FactoryGirl.define do

  factory :unified_gene_fusion_amoi, :class => UnifiedGeneFusion, parent: :confirmable_variant do
     driverReadCount 500
     partnerReadCount 499
     driverGene "NTRK1"
     partnerGene "TPM3"
     annotation "COSF1318"
     confirmed  false
  end

end