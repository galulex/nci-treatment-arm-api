# This gets rendered for displaying all the TreatmentArms
class TreatmentArmSerializer < ActiveModel::Serializer
  attributes :id, :name, :active, :date_created, :version, :stratum_id,
             :description, :target_id, :target_name, :gene,
             :treatment_arm_status, :study_id, :assay_rules,
             :num_patients_assigned, :date_opened, :treatment_arm_drugs,
             :diseases, :exclusion_drugs, :status_log,
             :snv_indels, :non_hotspot_rules,
             :copy_number_variants, :gene_fusions, :current_patients,
             :former_patients, :not_enrolled_patients, :pending_patients

  def active
    object.is_active_flag == 'true' ? true : false
  end

  def num_patients_assigned
    object.pending_patients + object.former_patients + object.not_enrolled_patients + object.current_patients
  end
end
