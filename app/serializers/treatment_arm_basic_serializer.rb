# This gets rendered when basic = { true|false } query params are passed
class TreatmentArmBasicSerializer < ActiveModel::Serializer
  attributes :name, :treatment_arm_status, :date_opened, :date_closed,
             :current_patients, :former_patients, :not_enrolled_patients,
             :pending_patients
end
