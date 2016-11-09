require 'spec_helper'

describe TreatmentArmSerializer do
  let(:object) do
    build_serializable(
      treatment_arm_id: 'APEC1621-A',
      treatment_arm_title: 'APEC1621-A (100)',
      name: 'Sample TreatmentArm',
      stratum_id: '100',
      active: true,
      version: '2016-20-02',
      description: 'This is the sample Description',
      target_id: 'HDFD',
      target_name: 'OtherHen',
      gene: 'GENE',
      treatment_arm_status: 'OPEN',
      study_id: 'APEC1621',
      assay_rules: [],
      total_patients_on_arm: 2,
      date_opened: '2016-10-05',
      treatment_arm_drugs: [
        {
        'drug_id': '113',
        'name': 'a'
        }
      ],
      diseases: [
        {
          'disease_code': '8200/0',
          'disease_code_type': 'ICD-O',
          'exclusion': false,
          'disease_name': 'Eccrine dermal cylindroma (C44._)\nTurban tumor (C44.4)\nCylindroma of skin (C44._)'
        }
      ],
      exclusion_drugs: [],
      status_log: [],
      snv_indels: [],
      non_hotspot_rules: [],
      copy_number_variants: [],
      gene_fusions: [],
      date_created: '2020-10-05',
      current_patients: 1,
      former_patients: 1,
      not_enrolled_patients: 1,
      pending_patients: 0
    )
  end

  subject { serialize(object) }

  it { should include(treatment_arm_id: 'APEC1621-A') }
  it { should include(treatment_arm_title:'APEC1621-A (100)') }
  it { should include(name: 'Sample TreatmentArm') }
  it { should include(stratum_id: '100') }
  it { should include(version: '2016-20-02') }
  it { should include(active: true) }
  it { should include(description: 'This is the sample Description') }
  it { should include(target_id: 'HDFD') }
  it { should include(target_name: 'OtherHen') }
  it { should include(gene: 'GENE') }
  it { should include(treatment_arm_status: 'OPEN') }
  it { should include(study_id: 'APEC1621') }
  it { should include(assay_rules: []) }
  it { should include(total_patients_on_arm: 2) }
  it { should include(date_created: '2020-10-05') }
  it { should include(date_opened: '2016-10-05') }
  it { should include(treatment_arm_drugs: [
        {
          'drug_id': '113',
          'name': 'a'
        }
      ]
    )
  }
  it { should include(diseases: [
        {
          'disease_code': '8200/0',
          'disease_code_type': 'ICD-O',
          'exclusion': false,
          'disease_name': 'Eccrine dermal cylindroma (C44._)\nTurban tumor (C44.4)\nCylindroma of skin (C44._)'
        }
      ]
    )
  }
  it { should include(exclusion_drugs: []) }
  it { should include(status_log: []) }
  it { should include(snv_indels: []) }
  it { should include(non_hotspot_rules: []) }
  it { should include(copy_number_variants: []) }
  it { should include(gene_fusions: []) }
  it { should include(version_statistics:
        {
          current_patients: 0,
          former_patients: 0,
          not_enrolled_patients: 0,
          pending_patients: 0
        }
      )
  }
end
