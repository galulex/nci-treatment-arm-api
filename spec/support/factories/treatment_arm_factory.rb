# require 'factory_girl'

FactoryGirl.define do
  factory :treatment_arm, :class => TreatmentArm do
    name 'EAY131-test'
    treatment_arm_id 'APEC1621-A'
    version '2016-20-02'
    stratum_id '12'
    active true
    date_created '2020-10-05'
    description 'This is the sample Description'
    target_id 'HDFD'
    treatment_arm_status 'OPEN'
    num_patients_assigned 2
    date_opened '2015-10-07'
    study_id 'APEC1621'
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
    status_log {}
    assay_rules []
    gene_fusions []
    non_hotspot_rules []
    copy_number_variants []
    not_enrolled_patients 1
    former_patients 1
    pending_patients 1
    current_patients 1
    version_pending_patients 1
    version_former_patients 2
    version_not_enrolled_patients 1
    version_current_patients 1
  end

  factory :treatment_arm_assignment_event, :class => TreatmentArmAssignmentEvent do
    assignment_date '2012-02-20'
    date_on_arm '2016-05-27'
    date_off_arm '2013-01-19'
    patient_id '200re'
    treatment_arm_id 'EAC123'
    stratum_id 'EAY131'
    patient_status 'PENDING_CONFIRMATION'
    assignment_reason ''
    diseases [
      { 'drug_id': '1234' }
    ]
    version '2012-02-20'
    step_number '0'
    analysis_id '1'
    molecular_id '2'
    surgical_event_id '3'
    variant_report {}
    assignment_report {}
    event 'EVENT_INIT'
  end
end