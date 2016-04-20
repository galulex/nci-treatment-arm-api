require 'mongoid'

class BasicTreatmentArm
  include Mongoid::Document

  store_in collection: "basic_treatment_arm"

  field :_id, type: String, default: ->{ _id }
  field :treatment_arm_name, type: String
  field :current_patients, type: Integer
  field :former_patients, type: Integer
  field :not_enrolled_patients, type: Integer
  field :pending_patients, type: Integer
  field :treatment_arm_status
  field :date_created
  field :date_opened
  field :date_closed
  field :date_suspended

end

