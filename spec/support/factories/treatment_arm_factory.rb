# require 'factory_girl'

FactoryGirl.define do
  factory :treatment_arm, :class => TreatmentArm do
    name 'EAY131-test'
    treatment_arm_id 'APEC1621-A'
    version '2016-20-02'
    stratum_id '12'
    date_created '2020-10-05'
    description 'This is the sample Description'
    target_id 'HDFD'
    target_name 'OtherHen'
    gene 'GENE'
    treatment_arm_drugs [{
        'drug_id': '113',
        'name': 'a'}]
    snv_indels [
        {
          'position': '30035190',
          'ocp_alternative': '-',
          'gene': 'NRAS',
          'protein': 'p.Q61H',
          'level_of_evidence': '3.0',
          'ocp_reference': 'TTC',
          'variant_type': 'snp',
          'chromosome': 'chr22',
          'arm_specific': false,
          'identifier': 'COSM22189',
          'public_med_ids': ['18827604', '21917678', '23181703'],
          'inclusion': true
         }
       ]
    diseases [
        {
          'disease_code': '8200/0',
          'disease_code_type': 'ICD-O',
          'exclusion': false,
          'disease_name': 'Eccrine dermal cylindroma (C44._)\nTurban tumor (C44.4)\nCylindroma of skin (C44._)'
        }
      ]
    exclusion_drugs []
  end

  factory :treatmentArmVersions, :class => TreatmentArm do
    name 'EAY131-test-Version'
    version Time.now
  end
end