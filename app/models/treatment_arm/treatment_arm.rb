
require './lib/extensions/hash_extension'

class TreatmentArm
  include Aws::Record
  include Aws::Record::RecordClassMethods
  include Aws::Record::ItemOperations::ItemOperationsClassMethods

  include ActiveModel::Serializers::JSON
  include ModelSerializer

  set_table_name "#{self.name.underscore}"

  boolean_attr :active, database_attribute_name: 'is_active_flag'
  string_attr :treatment_arm_id, hash_key: true
  string_attr :name
  string_attr :version
  string_attr :date_created, range_key: true
  string_attr :stratum_id
  string_attr :description
  string_attr :target_id
  string_attr :target_name
  string_attr :gene
  string_attr :treatment_arm_status
  string_attr :study_id
  list_attr :assay_rules
  integer_attr :num_patients_assigned
  string_attr :date_opened
  list_attr :treatment_arm_drugs
  list_attr :diseases
  list_attr :exclusion_drugs
  list_attr :snv_indels
  list_attr :non_hotspot_rules
  list_attr :copy_number_variants
  list_attr :gene_fusions
  map_attr :status_log
  integer_attr :version_current_patients
  integer_attr :version_former_patients
  integer_attr :version_not_enrolled_patients
  integer_attr :version_pending_patients
  integer_attr :current_patients
  integer_attr :former_patients
  integer_attr :not_enrolled_patients
  integer_attr :pending_patients

  def self.find_by(id=nil, stratum_id=nil, version=nil, to_hash=true)
    query = {}
    query.merge!(build_scan_filter(id, stratum_id, version))
    if append_and?( !id.nil?, !stratum_id.nil?, !version.nil? )
      query.merge!(conditional_operator: 'AND')
    end
    if to_hash
      self.scan(query).collect(&:to_h)
    else
      self.scan(query).entries
    end
  end

  def self.build_scan_filter(id=nil, stratum_id=nil, version=nil)
    query = {:scan_filter => {}}
    unless id.nil?
      query[:scan_filter].merge!("treatment_arm_id" => {:comparison_operator => "EQ", :attribute_value_list => [id]})
    end
    unless stratum_id.nil?
      query[:scan_filter].merge!("stratum_id" => {:comparison_operator => "EQ", :attribute_value_list => [stratum_id]})
    end
    unless version.nil?
      query[:scan_filter].merge!("version" => {:comparison_operator => "EQ", :attribute_value_list => [version]})
    end
    query
  end

  def self.append_and?(a=false, b=false, c=false)
    (a && (b || c)) || (b && (c || a)) || (c && (a || b))
  end

  def clone_attributes
    attributes_data.merge!(date_created: nil)
  end

  def attributes_data
    attributes.as_json['data']['data']
  end

  def self.serialized_hash(treatment_arms, projection = [])
    return [] unless treatment_arms.present?
    if treatment_arms.is_a?(Array)
      attributes = treatment_arms.first.attributes_data.keys
      unwanted_attributes = projection.blank? ? [] : attributes - projection
      treatment_arms.collect { |t| t.attributes_data.delete_keys!(unwanted_attributes) }
    elsif treatment_arms.is_a?(TreatmentArm)
      attributes = treatment_arms.attributes_data.keys
      unwanted_attributes = attributes - projection
      treatment_arms.attributes_data.delete_keys!(unwanted_attributes)
    end
  end

  def self.async_cog_status_update
    begin
      result = []
      response = HTTParty.get(Rails.configuration.environment.fetch('cog_url') + Rails.configuration.environment.fetch('cog_treatment_arms'))
      cog_arms_status = response.parsed_response.deep_transform_keys!(&:underscore).symbolize_keys
      cog_arms_status[:treatment_arms].each do |cog_arm|
        match_treatment_arm = TreatmentArm.find_by(cog_arm['treatment_arm_id'], cog_arm['stratum_id'], nil, false).first
        unless match_treatment_arm.blank?
          next if match_treatment_arm.active == false
          if match_treatment_arm.treatment_arm_status != 'CLOSED' && match_treatment_arm.treatment_arm_status != cog_arm['status']
            Aws::Publisher.publish(cog_treatment_refresh: match_treatment_arm.attributes_data)
            match_treatment_arm.treatment_arm_status = cog_arm['status']
            result << match_treatment_arm.attributes_data
          end
        end
       Rails.logger.info("No Treatment Arms status to update")
      end
      result
    rescue => error
      Rails.logger.warn("Failed to connect to COG with error #{error}::#{error.backtrace}")
    end
  end

  def snv_identifiers
    snv_indels.collect{|indel| { indel["identifier"] => indel["inclusion"] }}.compact
  end

  def cnv_identifiers
    copy_number_variants.collect{|cnv| { cnv["identifier"] => cnv["inclusion"] }}
  end

  def gf_identifiers
    gene_fusions.collect{|fusion| { fusion["identifier"] => fusion["inclusion"] }}
  end
end
