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
    TreatmentArm.stratum_stats(object.treatment_arm_id, object.stratum_id)
  end

  def num_patients_assigned
    num = object.pending_patients.to_i
    p "======== num pending_patient: #{num}"
    num1 = object.former_patients.to_s.to_i
    p "======== num former_patients: #{num1}"
    num2 = object.not_enrolled_patients.to_s.to_i
    p "======== num not_enrolled_patients: #{num2}"
    num3 = object.current_patients.to_s.to_i
    p "======== num current_patients: #{num3}"
    # object.pending_patients + object.former_patients + object.not_enrolled_patients + object.current_patients
    num + num1 + num2 + num3
  end

  def treatment_arm_title
    "#{object.treatment_arm_id} (#{object.stratum_id})"
  end
end
