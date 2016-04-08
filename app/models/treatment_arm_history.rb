require 'mongoid'

class TreatmentArmHistory
  include Mongoid::Document

  store_in collection: "treatmentArmHistoryTest"

  field :dateArchived, type: DateTime, default: Time.now
  embeds_one :treatmentArm, class_name: "treatmentArm", inverse_of: :treatmentarmhisotry

end