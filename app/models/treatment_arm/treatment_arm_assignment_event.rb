class TreatmentArmAssignmentEvent
  include Aws::Record
  include Aws::Record::RecordClassMethods
  include Aws::Record::ItemOperations::ItemOperationsClassMethods

  set_table_name "#{self.name.underscore}"

  string_attr :patient_id, hash_key: true
  date_attr :assignment_date, range_key: true
  date_attr :date_on_arm
  date_attr :date_off_arm
  string_attr :treatment_arm_id
  string_attr :stratum_id
  string_attr :version
  string_attr :patient_status
  string_attr :event
  string_attr :assignment_reason
  list_attr :diseases
  string_attr :step_number
  string_attr :surgical_event_id
  string_attr :molecular_id
  string_attr :analysis_id
  map_attr :variant_report
  map_attr :assignment_report

  def self.find_by(opts = {},to_hash=true)
    query = {}
    query.merge!(build_scan_filter(opts))
    query.merge!(conditional_operator: 'AND') if query[:scan_filter].length >= 2
    if to_hash
      self.scan(query).collect(&:to_h)
    else
      self.scan(query)
    end
  end

  def self.build_scan_filter(opts = {})
    query = { scan_filter: {} }
    opts.each do |key, value|
      unless value.nil?
        query[:scan_filter].merge!(key.to_s => { comparison_operator: 'EQ',
                                                 attribute_value_list: [value] })
      end
    end
    query
  end

  def self.find_with_variant_stats(treatment_arm_id)
    stats = { "snv_indels" => {}, "cnv" => {}, "gene_fusions" => {} }
    reports =[ "snv_indels", "cnv", "gene_fusions" ]
    treatment_arm_assignments = TreatmentArmAssignmentEvent.find_by({"treatment_arm_id" => treatment_arm_id}, false)
    treatment_arm_assignments.each do |taa|
      reports.each do |report_name|
        stats[report_name].merge!(taa.matched_treament_arm(report_name)){|a,b,c| b + c}
      end
    end
    treatment_arm_assignments.collect(&:to_h) << { "stats_by_identifier" => stats } if treatment_arm_assignments.present?
  end

  def matched_treament_arm(report_name)
    result={}
    treatment_arm = ::TreatmentArm.where(id: treatment_arm_id, stratum_id: stratum_id, version: version).first
    if treatment_arm
      identifiers= treatment_arm.send("#{report_name}_identifiers")
      identifiers_by_count = send("#{report_name}_count_by_patient")
      identifiers.each do |identifier|
        if identifiers_by_count[identifier]
          result[identifier] = result[identifier].nil? ? identifiers_by_count[identifier] : result[identifier]+identifiers_by_count[identifier]
        else
          result[identifier] = 0
        end
      end
    end
    result
  end

  def snv_indels_count_by_patient
    result = {}
    if variant_report && variant_report["snv_indels"]
      variant_report["snv_indels"].each do |indel|
        if result[indel["identifier"]]
          result[indel["identifier"]] += 1
        else
          result[indel["identifier"]] = 1
        end
      end
    end
    result
  end

  def cnv_count_by_patient
    result = {}
    if variant_report && variant_report["copy_number_variants"]
      variant_report["copy_number_variants"].each do |cnv|
        if result[cnv["identifier"]]
          result[cnv["identifier"]] += 1
        else
          result[cnv["identifier"]] = 1
        end
      end
    end
    result
  end

  def gene_fusions_count_by_patient
    result = {}
    if variant_report && variant_report["gene_fusions"]
      variant_report["gene_fusions"].each do |fusion|
        if result[fusion["identifier"]]
          result[fusion["identifier"]] += 1
        else
          result[fusion["identifier"]] = 1
        end
      end
    end
    result
  end
end
