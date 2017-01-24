# This gets rendered for displaying all the TreatmentArms
class TreatmentArmSerializer < ActiveModel::Serializer
  attributes :treatment_arm_id, :treatment_arm_title, :name,
             :active, :date_created, :version, :stratum_id,
             :description, :target_id, :target_name, :gene,
             :treatment_arm_status, :study_id, :assay_rules,
             :num_patients_assigned, :total_patients_on_arm,
             :date_opened, :treatment_arm_drugs,
             :diseases, :exclusion_drugs, :status_log,
             :snv_indels, :non_hotspot_rules,
             :copy_number_variants, :gene_fusions,
             :version_statistics, :stratum_statistics

  def total_patients_on_arm
    object.version_current_patients.to_i + object.version_former_patients.to_i
  end

  def version_statistics
    {
      current_patients: object.version_current_patients.to_i,
      former_patients: object.version_former_patients.to_i,
      not_enrolled_patients: object.version_not_enrolled_patients.to_i,
      pending_patients: object.version_pending_patients.to_i
    }
  end

  def stratum_statistics
    {
      current_patients: object.current_patients.to_i,
      former_patients: object.former_patients.to_i,
      not_enrolled_patients: object.not_enrolled_patients.to_i,
      pending_patients: object.pending_patients.to_i
    }
  end

  def num_patients_assigned
    object.version_pending_patients.to_i + object.version_former_patients.to_i + object.version_not_enrolled_patients.to_i + object.version_current_patients.to_i
  end

  def treatment_arm_title
    "#{object.treatment_arm_id} (#{object.stratum_id})"
  end
end
