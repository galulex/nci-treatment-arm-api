# TreatmentArm Data Model (Dynamoid)
# TODO(Adithya) Revert back to AWS Record if Dynamoid has
# any issues
class TreatmentArm
  include Dynamoid::Document

  table name: 'treatment_arm', key: :id, range_key: :date_created

  field :id
  field :is_active_flag
  field :name
  field :date_created
  field :version
  field :stratum_id
  field :description
  field :target_id
  field :target_name
  field :gene
  field :treatment_arm_status
  field :study_id
  field :assay_rules, :array
  field :num_patients_assigned, :integer
  field :date_opened
  field :date_closed
  field :treatment_arm_drugs, :array
  field :diseases, :array
  field :exclusion_drugs, :array
  field :status_log, :serialized
  field :snv_indels, :array
  field :non_hotspot_rules, :array
  field :copy_number_variants, :array
  field :gene_fusions, :array
  field :current_patients, :integer
  field :former_patients, :integer
  field :not_enrolled_patients, :integer
  field :pending_patients, :integer

  def clone_attributes
    attributes.merge!(date_created: nil)
  end
end

