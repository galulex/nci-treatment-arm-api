# This gets rendered for displaying all the TreatmentArms
class TreatmentArmSerializer < ActiveModel::Serializer
  attributes :id, :treatment_arm_title, :name, :active, :date_created, :version, :stratum_id,
             :description, :target_id, :target_name, :gene,
             :treatment_arm_status, :study_id, :assay_rules,
             :num_patients_assigned, :total_patients_on_arm,
             :date_opened, :treatment_arm_drugs,
             :diseases, :exclusion_drugs, :status_log,
             :snv_indels, :non_hotspot_rules,
             :copy_number_variants, :gene_fusions, :version_statistics,
             :stratum_statistics

  def active
    object.is_active_flag == true ? true : false
  end

  def total_patients_on_arm
    0
  end

  def version_statistics
    {
      current_patients: object.current_patients,
      former_patients: object.former_patients,
      not_enrolled_patients: object.not_enrolled_patients,
      pending_patients: object.pending_patients
    }
  end

  def stratum_statistics
    TreatmentArm.stratum_stats(object.id, object.stratum_id)
  end

  def num_patients_assigned
    object.pending_patients + object.former_patients + object.not_enrolled_patients + object.current_patients
  end

  def treatment_arm_title
    "#{object.id} (#{object.stratum_id})"
  end
end
