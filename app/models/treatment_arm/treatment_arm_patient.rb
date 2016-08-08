class TreatmentArmPatient
  include Aws::Record
  include Aws::Record::RecordClassMethods
  include Aws::Record::ItemOperations::ItemOperationsClassMethods

  set_table_name "#{self.name.underscore}"

  string_attr :patient_id, hash_key: true
  date_attr :date_assigned, range_key: true

  string_attr :treatment_arm_name
  string_attr :stratum_id
  string_attr :version

  string_attr :concordance
  string_attr :patient_assignment_status
  string_attr :date_created
  string_attr :description

  list_attr :diseases
  list_attr :exclusion_criterias
  list_attr :exclusion_diseases
  list_attr :exclusion_drugs

  string_attr :gene
  string_attr :name

  list_attr :patient_assignments
  list_attr :pten_results

  string_attr :target_id
  string_attr :target_name

  list_attr :treatment_arm_drugs
  string_attr :treatment_arm_status
  list_attr :variant_report

  map_attr :status_log

  integer_attr :step_number

  def self.find_by(opts = {})
    query = {}
    query.merge!(build_scan_filter(opts))
    if query[:scan_filter].length >= 2
      query.merge!(:conditional_operator => "AND")
    end
    self.scan(query).collect { |data| data.to_h }
  end

  def self.build_scan_filter(opts = {})
    query = {:scan_filter => {}}
    opts.each do | key, value |
      if(!value.nil?)
        query[:scan_filter].merge!(key.to_s => {:comparison_operator => "EQ", :attribute_value_list => [value]})
      end
    end
    query
  end


end