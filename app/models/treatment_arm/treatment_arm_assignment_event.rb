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

  def self.find_by(opts = {}, to_hash=true)
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
    assignment_stats = { "snv_indels" => {}, "copy_number_variants" => {}, "gene_fusions" => {} }
    variant_stats = { "snv_indels" => {}, "copy_number_variants" => {}, "gene_fusions" => {} }
    variant_non_hotspot_stats = {}
    assignment_non_hotspot_stats = {}
    assay_stats = {}
    assignment_assay_stats = {}
    reports = { "snv" => "snv_indels", "cnv" => "copy_number_variants", "gf" => "gene_fusions" }
    treatment_arm_assignments = TreatmentArmAssignmentEvent.find_by({ "treatment_arm_id" => treatment_arm_id}, false).entries
    treatment_arm_assignments.each do |taa|
      reports.each do |report_name, stat_name|
        hash_merge(variant_stats[stat_name], taa.matched_treament_arm_for_variant_report(report_name))
        hash_merge(assignment_stats[stat_name], taa.matched_treament_arm_for_variant_report(report_name, "assignment"))
      end
        hash_merge(variant_non_hotspot_stats, taa.matched_treament_arm_for_non_hot_spot_rules("non_hotspot_rules"))
        hash_merge(assignment_non_hotspot_stats, taa.matched_treament_arm_for_non_hot_spot_rules("non_hotspot_rules_assignment"))
        hash_merge(assay_stats, taa.matched_treament_arm_for_assay_rules("assay_rules"))
        hash_merge(assignment_assay_stats, taa.matched_treament_arm_for_assay_rules("assignment_assay_rules"))
    end
    if treatment_arm_assignments.present?
      [
        { :patients_list => treatment_arm_assignments.collect(&:to_h),
          :stats => {
                      "variant_stats_by_identifier" => variant_stats,
                      "assginment_stats_by_identifier" => assignment_stats,
                      "variant_non_hotspot_stats" => variant_non_hotspot_stats,
                      "assignment_non_hotspot_stats" => assignment_non_hotspot_stats,
                      "assay_stats" => assay_stats,
                      "non_sequencing_assay_stats" => assignment_assay_stats
                    }
        }
      ]
    end
  end

  def treatment_arm
    @treatment_arm ||= ::TreatmentArm.where(treatment_arm_id: treatment_arm_id, stratum_id: stratum_id, version: version).first
  end

  def matched_treament_arm_for_non_hot_spot_rules(report_name)
    result = {}
    if treatment_arm
      ta_non_hotspot_rules = treatment_arm.non_hotspot_rules
      ta_non_hotspot_rules.each do |ta_rule|
        result[ta_rule["func_gene"]] = { "inclusion" => ta_rule["inclusion"] }
        if non_hotspot_rules
          non_hotspot_rules.each do |e_rule|
            if ta_rule["func_gene"] == e_rule["func_gene"] &&
              ta_rule["exon"] == e_rule["exon"] &&
              ta_rule["oncomine_variant_class"] == e_rule["oncomine_variant_class"] &&
              ta_rule["function"] == e_rule["function"]
              if result[ta_rule["func_gene"]]["count"]
                result[ta_rule["func_gene"]]["count"] +=1
              else
                result[ta_rule["func_gene"]]["count"] = 1
              end
            end
          end
        end
      end
    end
    result
  end

  def matched_treament_arm_for_assay_rules(report_name)
    result = {}
    if treatment_arm
      ta_assay_rules = treatment_arm.assay_rules
      ta_assay_rules.each do |ta_rule|
        if assay_rules
          assay_rules.each do |e_rule|
            flag = false
            if report_name == "assignment_assay_rules"
              flag = true if ta_rule["gene"] == e_rule["gene"] &&
                ta_rule["assay_result_status"] == e_rule["status"] &&
                ta_rule["assay_variant"] == e_rule["assay_variant"]
            else
              flag = true if ta_rule["gene"] == e_rule["gene"] &&
                ta_rule["assay_result_status"] == e_rule["status"]
            end
            if flag
              if result[ta_rule["gene"]]
                result[ta_rule["gene"]]["count"] += 1
              else
                result[ta_rule["gene"]] = { :count => 1 }
              end
            end
          end
        end
      end
    end
    result
  end

  def assay_rules
    assignment_report["patient"]["assay_results"].collect do |rule|
      {
        "gene" => rule["gene"],
        "status" => rule["status"]
      }
    end if assignment_report && assignment_report["patient"]["assay_results"]
  end

  def assignment_assay_rules
    result = []
    if assignment_report && assignment_report["treatment_assignment_results"]
      assignment_report["treatment_assignment_results"].each do |ta|
        ta["assay_rule_results"].each do |rule|
          result << {
            "gene" => rule["gene"],
            "status" => rule["assay_result_status"],
            "assay_variant" => rule["assay_variant"]
          }
        end
      end
    end
    result
  end

  def matched_treament_arm_for_variant_report(report_name, report_suffix=nil)
    result = {}
    if treatment_arm
      identifiers = treatment_arm.send("#{report_name}_identifiers")
      if report_suffix
        identifiers_by_count = send("#{report_suffix}_#{report_name}_count_by_patient")
      else
        identifiers_by_count = send("#{report_name}_count_by_patient")
      end
      identifiers.each do |identifier_hash|
        identifier_hash.each do |identifier, inclusion|
          result[identifier] = { "inclusion" => inclusion }
          if identifiers_by_count[identifier]
            result[identifier]["count"] = result[identifier]["count"].nil? ? identifiers_by_count[identifier] : result[identifier]["count"] + identifiers_by_count[identifier]
          else
            result[identifier]["count"] = 0
          end
        end
      end
    end
    result
  end

  def snv_count_by_patient
    result = {}
    if variant_report && variant_report["snv_indels"]
      variant_report["snv_indels"].each do |indel|
        next if indel["confirmed"] != true
        if result[indel["identifier"]]
          result[indel["identifier"]] += 1
        else
          result[indel["identifier"]] = 1
        end
      end
    end
    result
  end

  def assignment_snv_count_by_patient
    result = {}
    if assignment_report && assignment_report["patient"] && assignment_report["patient"]["snv_indels"]
      assignment_report["patient"]["snv_indels"].each do |indel|
        next if indel["confirmed"] == false
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
        next if cnv["confirmed"] != true
        if result[cnv["identifier"]]
          result[cnv["identifier"]] += 1
        else
          result[cnv["identifier"]] = 1
        end
      end
    end
    result
  end

  def assignment_cnv_count_by_patient
    result = {}
    if assignment_report && assignment_report["patient"] && assignment_report["patient"]["copy_number_variants"]
      assignment_report["patient"]["copy_number_variants"].each do |cnv|
        next if cnv["confirmed"] != true
        if result[cnv["identifier"]]
          result[cnv["identifier"]] += 1
        else
          result[cnv["identifier"]] = 1
        end
      end
    end
    result
  end

  def gf_count_by_patient
    result = {}
    if variant_report && variant_report["gene_fusions"]
      variant_report["gene_fusions"].each do |fusion|
        next if fusion["confirmed"] != true
        if result[fusion["identifier"]]
          result[fusion["identifier"]] += 1
        else
          result[fusion["identifier"]] = 1
        end
      end
    end
    result
  end

  def assignment_gf_count_by_patient
    result = {}
    if assignment_report && assignment_report["patient"] && assignment_report["patient"]["gene_fusions"]
      assignment_report["patient"]["gene_fusions"].each do |fusion|
        next if fusion["confirmed"] != true
        if result[fusion["identifier"]]
          result[fusion["identifier"]] += 1
        else
          result[fusion["identifier"]] = 1
        end
      end
    end
    result
  end

  def non_hotspot_rules
    variant_report["snv_indels"].collect do |indel|
      {
        "func_gene" => indel["func_gene"],
        "exon" => indel["exon"],
        "oncomine_variant_class" => indel["oncomine_variant_class"],
        "function" => indel["function"]
      }
    end if variant_report && variant_report["snv_indels"]
  end

  def non_hotspot_rules_assignment
    assignment_report["patient"]["snv_indels"].collect do |indel|
      {
        "func_gene" => indel["func_gene"],
        "exon" => indel["exon"],
        "oncomine_variant_class" => indel["oncomine_variant_class"],
        "function" => indel["function"]
      }
    end if assignment_report && assignment_report["patient"]["snv_indels"]
  end

  def self.hash_merge(hash1, hash2)
    hash1.merge!(hash2) do |a,b,c|
      b.merge!(c) do |x,y,z|
        if y.is_a?(Integer)
          y + z
        else
          y
        end
      end
    end
    hash1
  end
end
