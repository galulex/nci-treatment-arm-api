# This gets rendered for displaying all the TreatmentArms
class TreatmentArmSerializer < ActiveModel::Serializer
  attributes :name, :active, :id, :date_created, :version, :stratum_id,
             :description, :target_id, :target_name, :gene,
             :treatment_arm_status, :study_id, :assay_rules,
             :num_patients_assigned, :date_opened, :treatment_arm_drugs,
             :diseases, :exclusion_drugs, :status_log,
             :single_nucleotide_variants, :indels, :non_hotspot_rules,
             :copy_number_variants, :gene_fusions, :current_patients,
             :former_patients, :not_enrolled_patients, :pending_patients

  def active
    object.active == 'true' ? true : false
  end

  def id
    object.name
  end
end
