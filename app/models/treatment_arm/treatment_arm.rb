
class TreatmentArm
  include Aws::Record
  include Aws::Record::RecordClassMethods
  include Aws::Record::ItemOperations::ItemOperationsClassMethods

  include ActiveModel::Serializers::JSON
  include ModelSerializer

  set_table_name "#{ENV['table_prefix']}_#{self.name.underscore}_#{Rails.env}"

  boolean_attr :active, database_attribute_name: "is_active_flag"
  string_attr :name, hash_key: true
  datetime_attr :date_created, range_key: true
  string_attr :version
  string_attr :stratum_id
  string_attr :description
  string_attr :target_id
  string_attr :target_name
  string_attr :gene
  string_attr :treatment_arm_status
  string_attr :study_id

  list_attr :assay_results
  integer_attr :num_patients_assigned
  string_attr :date_opened
  list_attr :treatment_arm_drugs
  map_attr :variant_report
  list_attr :exclusion_diseases
  list_attr :inclusion_diseases
  list_attr :exclusion_drugs
  list_attr :pten_results
  map_attr :status_log

  integer_attr :current_patients
  integer_attr :former_patients
  integer_attr :not_enrolled_patients
  integer_attr :pending_patients


  def self.find_by(id, stratum_id=nil, version=nil)
    query = {}
    query.merge!(build_scan_filter(id, stratum_id, version))
    if !(stratum_id.nil? || version.nil?)
      query.merge!(:conditional_operator => "AND")
    end
    self.scan(query).collect { |data| data.to_h }
  end

  def self.build_scan_filter(id=nil, stratum_id=nil, version=nil)
    query = {:scan_filter => {}}
    if(!id.nil?)
      query[:scan_filter].merge!("name" => {:comparison_operator => "EQ", :attribute_value_list => [id]})
    end
    if(!stratum_id.nil?)
      query[:scan_filter].merge!("stratum_id" => {:comparison_operator => "EQ", :attribute_value_list => [stratum_id]})
    end
    if(!version.nil?)
      query[:scan_filter].merge!("version" => {:comparison_operator => "EQ", :attribute_value_list => [version]})
    end
    query
  end

  def self.find_basic_treatment_arm_by(id=nil)
    query = {}
    query.merge!(build_scan_filter(id))
    query.merge!({:attributes_to_get => ["name",
                                         "stratum_id",
                                         "current_patients",
                                         "former_patients",
                                         "not_enrolled_patients",
                                         "pending_patients",
                                         "date_opened",
                                         "treatment_arm_status",
                                         "date_opened","date_created"]})
    TreatmentArm.scan(query).collect { |data| data.to_h }.uniq { | arm | arm[:name] }
  end

end

