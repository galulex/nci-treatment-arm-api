
FactoryGirl.define do

  factory :nonHotspotRulesAmoi, :class => NonHotspotRule, parent: :variant_faker do
    gene { ["MYCL", "KRAS", "PPP2R1A"].sample }
    proteinMatch {["p.Gly13Asp","p.match770neg"].sample }
    rare { [true, false].sample }
    levelOfEvidence { rand(1000) }
    inclusion true
    armSpecific false
  end

  factory :non_Hotspot_Rule_faker, :class => NonHotspotRule, parent: :variant_faker do
    oncominevariantclass { ["Hotspot", "Fusion"].sample }
    gene { ["MYCL", "KRAS", "PPP2R1A"].sample }
    function { ["missense", ""].sample }
    proteinMatch ""
    exon { rand(0..50).to_s }
    rare { [true, false].sample }
    levelOfEvidence { rand(1000) }
    inclusion true
    armSpecific false
  end

end