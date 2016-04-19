require 'mongoid'

  class TreatmentArm
    include Mongoid::Document

    store_in collection: "treatmentArm"

    field :_id, type: String
    field :name
    field :version
    field :current_version, type: String
    field :description
    field :target_id
    field :target_name
    field :gene
    field :treatment_arm_status
    field :previous_versions, type: Array

    embeds_many :treatment_arm_drugs, class_name: "Drug", inverse_of: :treatmentarm
    embeds_many :exclusion_diseases, class_name: "Disease", inverse_of: :treatmentarm
    embeds_many :exclusion_drugs, class_name: "Drug", inverse_of: :treatmentarm
    embeds_many :exclusion_criterias, class_name: "ExclusionCriteria", inverse_of: :treatmentarm
    embeds_many :pten_results, class_name: "PtenResult", inverse_of: :treatmentarm

    field :num_patients_assigned, type: Integer, default: 0
    field :max_patients_allowed, type: Integer


    embeds_one :variant_report, class_name: "VariantReport", inverse_of: :treatmentarm

    field :statusLog, type: Hash

    field :date_created, type: DateTime, default: Time.now

    # embedded_in :treatmentarmhistory, :inverse_of => :treatmentArm

    def validate_eligible_for_approval(id)
      treatment_arm = TreatmentArm.where(:_id => id, :treatment_arm_status.ne => "PENDING").first
      is_valid = treatment_arm.variantReport.has_a_inclusion
      if treatment_arm.ptenResults.empty? && is_valid
        return true
      end
      if treatment_arm.ptenResults.collect { | pten | pten.get_pten_variant_status}.include? PtenResult.empty?
        return true
      end
      return is_valid
    end

    def get_number_screened_patients_with_amoi(patientData)
      TreatmentArm.where(:variant_report.ne => "", :variant_report.exists => true).each do | treatmentArm |

      end

    end

  end

