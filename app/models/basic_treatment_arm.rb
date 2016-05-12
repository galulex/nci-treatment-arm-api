class BasicTreatmentArm
  # include Dynamoid::Document

  #
  #
  # field :treatment_arm_id
  # field :current_patients
  # field :treatment_arm_name
  # field :current_patients
  # field :former_patients
  # field :not_enrolled_patients
  # field :pending_patients
  # field :treatment_arm_status
  # field :date_created, :datetime
  # field :date_opened, :datetime
  # field :date_closed, :datetime
  # field :date_suspended, :datetime

  include Aws::Record
  include Aws::Record::RecordClassMethods
  include Aws::Record::Query::QueryClassMethods

  set_table_name "ta_basic_treatment_arm_dev"

  string_attr :treatment_arm_id, hash_key: true
  string_attr :description
  string_attr :treatment_arm_status
  string_attr :date_created
  string_attr :date_opened

  integer_attr :current_patients
  integer_attr :former_patients
  integer_attr :not_enrolled_patients
  integer_attr :pending_patients

end
