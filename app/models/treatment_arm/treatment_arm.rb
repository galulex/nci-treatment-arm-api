# TODO(Adithya) Revert back to AWS Record if Dynamoid has
# any issues
require './lib/extensions/hash_extension'
# TreatmentArm Data Model (Dynamoid)
class TreatmentArm
  include Dynamoid::Document

  table name: 'treatment_arm', key: :id, range_key: :date_created

  field :id
  field :is_active_flag, :boolean
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

  def self.serialized_hash(treatment_arms, projection = [])
    return [] unless treatment_arms.present?
    if treatment_arms.is_a?(Array)
      attributes = treatment_arms.first.as_json.keys
      unwanted_attributes = projection.blank? ? [] : attributes - projection
      treatment_arms.collect { |t| t.as_json.delete_keys!(unwanted_attributes) }
    elsif treatment_arms.is_a?(TreatmentArm)
      attributes = treatment_arms.as_json.keys
      unwanted_attributes = attributes - projection
      treatment_arms.as_json.delete_keys!(unwanted_attributes)
    end
  end

  def self.cog_status_sync
    begin
      results = HTTParty.get(ENV['cog_url'] + ENV['cog_treatment_arms'])
      cog_arms_status = results.parsed_response.deep_transform_keys!(&:underscore).symbolize_keys!
      cog_arms_status[:treatment_arms].each do |cog_arm|
        match_treatment_arm = TreatmentArm.where(id: cog_arm['treatment_arm_id'],
                                                 stratum_id: cog_arm['stratum_id']).first
        unless match_treatment_arm.blank?
          if match_treatment_arm.treatment_arm_status != 'CLOSED' && match_treatment_arm.treatment_arm_status != cog_arm['status']
            match_treatment_arm.treatment_arm_status = cog_arm['status']
            #match_treatment_arm.save
            #logger.info("Treatment arm #{cog_arm[:treatment_arm_id]} (#{cog_arm[:stratum_id]}) has been updated")
          else
            p "error"
            #logger.info("Treatment arm #{cog_arm[:treatment_arm_id]} (#{cog_arm[:stratum_id]}) is currently CLOSED or Already in the correct state")
          end
        end
       # logger.info('No Treatment Arms status to update')
      end
    rescue Exception => e
      p "#{e.message}"
      #logger.warn("Unable to sync treatment_arm with cog #{e}")
    end
  end

  def self.stratum_stats(id, stratum_id)
    result = {
                current_patients: 0,
                former_patients: 0,
                not_enrolled_patients: 0,
                pending_patients: 0
             }
    treatment_arms = TreatmentArm.where(id: id, stratum_id: stratum_id)
    treatment_arms.each do |treatment_arm|
      result[:current_patients] += treatment_arm.current_patients
      result[:former_patients] += treatment_arm.former_patients
      result[:not_enrolled_patients] += treatment_arm.not_enrolled_patients
      result[:pending_patients] += treatment_arm.pending_patients
    end
    result
  end

  def snv_identifiers
    snv_indels.collect{|indel| { indel["identifier"] => indel["inclusion"] }}.compact
  end

  def cnv_identifiers
    copy_number_variants.collect{|cnv| { cnv["identifier"] => cnv["inclusion"] }}
  end

  def gf_identifiers
    copy_number_variants.collect{|fusion| { fusion["identifier"] => fusion["inclusion"] }}
  end
end
