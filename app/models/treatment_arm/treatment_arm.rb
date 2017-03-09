require './lib/extensions/hash_extension'
# TreatmentArm Data Model
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

  def self.find_by(id = nil, stratum_id = nil, version = nil, to_hash = true)
    query = {}
    query.merge!(build_scan_filter(id, stratum_id, version))
    query[:conditional_operator] = 'AND' if query[:scan_filter].length >= 2
    if to_hash
      scan(query).collect(&:to_h)
    else
      scan(query).entries
    end
  end

  def self.build_scan_filter(id = nil, stratum_id = nil, version = nil)
    query = { scan_filter: {} }
    unless id.nil?
      query[:scan_filter]['treatment_arm_id'] = { comparison_operator: 'EQ', attribute_value_list: [id] }
    end
    unless stratum_id.nil?
      query[:scan_filter]['stratum_id'] = { comparison_operator: 'EQ', attribute_value_list: [stratum_id] }
    end
    unless version.nil?
      query[:scan_filter]['version'] = { comparison_operator: 'EQ', attribute_value_list: [version] }
    end
    query
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
      treatment_arms = TreatmentArm.scan({})
      Rails.logger.info('===== Getting the Latest TreatmentArm statuses from COG =====')
      Rails.logger.info("===== Connecting to COG at #{Rails.configuration.environment.fetch('cog_url')} =====")
      auth = { username: Rails.configuration.environment.fetch('cog_user_name'), password: Rails.configuration.environment.fetch('cog_pwd') } if Rails.env.uat?
      Rails.logger.info("===== DEBUGGING_TA_STATUS auth nil: #{auth.nil?} =====")
      response = HTTParty.get(Rails.configuration.environment.fetch('cog_url') + Rails.configuration.environment.fetch('cog_treatment_arms'), basic_auth: auth)
      Rails.logger.info("===== DEBUGGING_TA_STATUS response from cog nil?: #{response.nil?} =====")
      cog_arms = response.parsed_response.deep_transform_keys!(&:underscore).symbolize_keys
      Rails.logger.info("===== DEBUGGING_TA_STATUS parsed response: #{cog_arms}")
      treatment_arms.each do |treatment_arm|
        next if treatment_arm.active == false
        cog_arms[:treatment_arms].each do |cog_arm|
          if cog_check_condition(cog_arm, treatment_arm)
            Rails.logger.info('===== Change in the TreatmentArm Status detected while comparing with COG. Saving Changes to the DataBase =====')
            Rails.logger.info("===== Sending TreatmentArm('#{treatment_arm.treatment_arm_id}'/'#{treatment_arm.stratum_id}'/'#{treatment_arm.version}') onto the queue to save to the DataBase  =====")
            Aws::Publisher.publish(cog_treatment_refresh: treatment_arm.attributes_data)
            treatment_arm.treatment_arm_status = cog_arm['status']
          end
        end
        result << treatment_arm
      end
      Rails.logger.info("===== DEBUGGING_TA_STATUS returning results: #{result}")
      result
    rescue => error
      Rails.logger.info("Failed connecting to COG :: #{error}")
      if Rails.env.uat?
        Rails.logger.info('===== Switching to use mock COG for UAT... =====')
        Rails.logger.info("===== Connecting to Mock cog at #{Rails.configuration.environment.fetch('mock_cog_url')} =====")
        MockCogService.perform
      end
    end
  end

  def self.cog_check_condition(cog_arm, treatment_arm)
    true if cog_arm['treatment_arm_id'] == treatment_arm.treatment_arm_id &&
            cog_arm['stratum_id'] == treatment_arm.stratum_id &&
            treatment_arm.treatment_arm_status != 'CLOSED' &&
            treatment_arm.treatment_arm_status != cog_arm['status']
  end

  def snv_identifiers
    snv_indels.collect { |indel| { indel['identifier'] => indel['inclusion'] } }.compact
  end

  def cnv_identifiers
    copy_number_variants.collect { |cnv| { cnv['identifier'] => cnv['inclusion'] } }.compact
  end

  def gf_identifiers
    gene_fusions.collect { |fusion| { fusion['identifier'] => fusion['inclusion'] } }.compact
  end

  def self.find_treatment_arm(treatment_arm_id, stratum_id)
    treatment_arms = self.query(
      key_condition_expression: "#T = :t",
      filter_expression: "contains(#S, :s)",
      expression_attribute_names: {
        "#T" => "treatment_arm_id",
        "#S" => "stratum_id"
      },
      expression_attribute_values: {
        ":t" => treatment_arm_id,
        ":s" => stratum_id
      }
    )
    treatment_arms
  end

  def self.remove_trailing_spaces(treatment_arm)
    return nil if treatment_arm.blank?
    treatment_arm.each_value do |value|
      next if check_condition(value)
      if value.is_a?(Array)
        value.each do |val|
          val.each_value do |v|
            next if check_condition(v)
            if v.is_a?(Array)
              v.collect!(&:squish)
            else
              v.strip!
            end
          end
        end
      else
        value.strip!
      end
    end
    treatment_arm
  end

  def self.check_condition(v)
    true if v.class == TrueClass || v.class == FalseClass || v.class == Float || v.class == NilClass || v.class == Fixnum
  end
end
