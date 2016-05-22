
class TreatmentArm
    include Aws::Record
    include Aws::Record::RecordClassMethods
    include Aws::Record::ItemOperations::ItemOperationsClassMethods

    include ActiveModel::Serializers::JSON
    include ActiveModel::Validations

    set_table_name "#{ENV['table_prefix']}_#{self.name.underscore}_#{Rails.env}"

    validates_presence_of :name, :version, :study_id

    boolean_attr :active, database_attribute_name: "is_active_flag"
    string_attr :name, hash_key: true
    string_attr :version, range_key: true
    string_attr :description
    string_attr :random_variable
    string_attr :target_id
    string_attr :target_name
    string_attr :gene
    string_attr :treatment_arm_status
    string_attr :study_id

    integer_attr :max_patients_allowed
    integer_attr :num_patients_assigned
    string_attr :date_created
    list_attr :treatment_arm_drugs
    map_attr :variant_report
    list_attr :exclusion_criterias
    list_attr :exclusion_diseases
    list_attr :exclusion_drugs
    list_attr :pten_results
    map_attr :status_log


    def convert_models(treatment_arm)
      return {
          name: treatment_arm[:id],
          version: treatment_arm[:version],
          study_id: treatment_arm[:study_id],
          description: treatment_arm[:description],
          target_id: treatment_arm[:target_id],
          target_name: treatment_arm[:target_name],
          gene: treatment_arm[:gene],
          treatment_arm_status: treatment_arm[:treatment_arm_status],
          date_created: treatment_arm[:date_created].blank? ? DateTime.current.getutc().to_s : treatment_arm[:date_created],
          max_patients_allowed: treatment_arm[:max_patients_allowed],
          num_patients_assigned: treatment_arm[:num_patients_assigned],
          treatment_arm_drugs: treatment_arm[:treatment_arm_drugs],
          exclusion_criterias: treatment_arm[:exclusion_criterias],
          exclusion_diseases: treatment_arm[:exclusion_diseases],
          exclusion_drugs: treatment_arm[:exclusion_drugs],
          pten_results: treatment_arm[:pten_results],
          status_log: treatment_arm[:status_log],
          variant_report: treatment_arm[:variant_report]
      }
    end

    def attributes=(hash)
        hash.each do |key, value|
            send("#{key}=", value)
        end
    end

    def attributes
        instance_values
    end

end

