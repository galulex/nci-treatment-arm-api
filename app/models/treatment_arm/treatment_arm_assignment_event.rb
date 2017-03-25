# TreatmentArmAssignmentEvent Data Model
class TreatmentArmAssignmentEvent
  include Aws::Record
  include Aws::Record::RecordClassMethods
  include Aws::Record::ItemOperations::ItemOperationsClassMethods

  set_table_name "#{self.name.underscore}"

  string_attr :treatment_arm_id_stratum_id, hash_key: true
  datetime_attr :assignment_date, range_key: true
  string_attr :patient_id
  string_attr :treatment_arm_id
  string_attr :treatment_arm_status
  string_attr :patient_status_reason
  datetime_attr :date_on_arm
  datetime_attr :date_off_arm
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

  def self.find_by(opts = {}, to_hash = true)
    query = {}
    query.merge!(build_scan_filter(opts))
    query[:conditional_operator] = 'AND' if query[:scan_filter].length >= 2
    if to_hash
      scan(query).to_h
    else
      scan(query)
    end
  end

  def self.build_scan_filter(opts = {})
    query = { scan_filter: {} }
    opts.each do |key, value|
      unless value.nil?
        query[:scan_filter].merge!(key.to_s => { comparison_operator: 'EQ', attribute_value_list: [value] })
      end
    end
    query
  end

  def self.find_with_variant_stats(treatment_arm_id, stratum_id, status)
    statuses = %w(PREVIOUSLY_ON_ARM PREVIOUSLY_ON_ARM_OFF_STUDY NOT_ENROLLED_ON_ARM NOT_ENROLLED_ON_ARM_OFF_STUDY)
    treatment_arm_assignments = TreatmentArmAssignmentEvent.find_by({ 'treatment_arm_id' => treatment_arm_id, 'stratum_id' => stratum_id, 'treatment_arm_status' => status }, false).entries
    treatment_arm_assignments.each do |assignment|
      assignment.assignment_reason = assignment.patient_status_reason if statuses.include?(assignment.patient_status)
    end

    if treatment_arm_assignments.present?
      {
        patients_list: treatment_arm_assignments.collect(&:to_h)
      }
    end
  end
end
