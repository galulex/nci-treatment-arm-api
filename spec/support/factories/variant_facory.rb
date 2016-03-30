
FactoryGirl.define do

  factory :variant_faker, :class => Variant do
    publicMedIds []
    geneName { ["PIK3CA", "KRAS", "PPP2R1A"].sample}
    chromosome { ["chr12", "chr3", "chr1", "chr13"].sample }
    position { ["178952085", "5640234", "2132858"].sample }
    identifier { ["COSM775", "COSM532", "."].sample}
    reference { ["G", "C", "A"].sample}
    alternative { ["T", "G", "C"].sample}
    filter { ["PASS", "FAIL"].sample}
    description {Faker::Book.title}
    protein { ["p.His1047Arg", "p.Gly13Asp", "p.Arg183Pro"].sample}
    transcript { ["NM_006218.2", "NM_033360.3", "NM_014225.5"].sample}
    hgvs { ["c.3140A>G", "c.38G>A", "c.548G>C"].sample}
    location { ["exonic", ""].sample}
    readDepth { rand(0..3000) }
    rare { [true, false].sample }
    alleleFrequency { rand(0..5.5)}
    flowAlternativeAlleleObservationCount { rand(1000).to_s }
    flowReferenceAlleleObservations { rand(1000).to_s }
    referenceAlleleObservations { rand(1000) }
    alternativeAlleleObservationCount { rand(1000) }
    variantClass ""
    levelOfEvidence { rand(0..5) }
    inclusion true
    armSpecific false
  end

  factory :variant_amoi_faker, :class => Variant, parent: :variant_faker do

  end

end