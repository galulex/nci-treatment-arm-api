require 'mongoid'

class BasicTreatmentArm
  include Mongoid::Document

  store_in collection: "basic_treatment_arm"

  field :_id, type: String, default: ->{ _id }
  field :treatmentArmName, type: String
  field :currentPatients, type: Integer
  field :formerPatients, type: Integer
  field :notEnrolledPatients, type: Integer
  field :pendingPatients, type: Integer
  field :treatmentArmStatus
  field :dateCreated, type: DateTime, default: Time.now
  field :dateOpened, type: DateTime
  field :dateClosed, type: DateTime
  field :dateSuspended, type: DateTime

end

