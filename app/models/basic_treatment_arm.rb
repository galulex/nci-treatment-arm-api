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
  field :date_created, type: DateTime, default: Time.now
  field :date_opened, type: DateTime
  field :date_closed, type: DateTime
  field :date_suspended, type: DateTime

end

