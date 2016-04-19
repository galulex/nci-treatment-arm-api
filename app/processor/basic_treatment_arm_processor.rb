require 'treatment_arm'
require 'date'

class BasicTreatmentArmProcessor

  def initialize
    @basic_treatment_arm_array = []
  end

  def create_treatment_arm_hash
    TreatmentArm.all.each do | treatment_arm |
      sorted_status_log = !treatment_arm[:statusLog].blank? ? treatment_arm[:statusLog].sort_hash_descending  : {}
      @basic_treatment_arm = {:treatmentArmId => treatment_arm[:_id],
                              :treatment_arm_name => treatment_arm[:name],
                              :current_patients => treatment_arm[:numPatientsAssigned],
                              :former_patients => 0,
                              :not_enrolled_patients => 0,
                              :pending_patients => 0,
                              :treatment_arm_status => treatment_arm[:treatment_arm_status],
                              :date_created => (treatment_arm[:date_created]).to_time.to_i,
                              :date_opened => sorted_status_log.key("OPEN"),
                              :date_closed => sorted_status_log.key("CLOSED"),
                              :date_suspended => sorted_status_log.key("SUSPENDED")
      }

      @basic_treatment_arm_array.push(@basic_treatment_arm)

    end

    return @basic_treatment_arm_array

  end

end
