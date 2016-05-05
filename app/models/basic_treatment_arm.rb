class BasicTreatmentArm
  include Dynamoid::Document

  field :treatment_arm_id
  field :current_patients
  field :treatment_arm_name
  field :current_patients
  field :former_patients
  field :not_enrolled_patients
  field :pending_patients
  field :treatment_arm_status
  field :date_created, :datetime
  field :date_opened, :datetime
  field :date_closed, :datetime
  field :date_suspended, :datetime

end
