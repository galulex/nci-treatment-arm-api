# This gets rendered when basic = { true|false } query params are passed
 class TreatmentArmBasicSerializer < ActiveModel::Serializer
   attributes :id, :name, :stratum_id, :treatment_arm_status, :date_opened, :date_closed,
              :current_patients, :former_patients, :not_enrolled_patients,
              :pending_patients
 end
