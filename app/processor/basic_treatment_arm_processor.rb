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
                              :treatmentArmName => treatment_arm[:name],
                              :currentPatients => treatment_arm[:numPatientsAssigned],
                              :formerPatients => 0,
                              :notEnrolledPatients => 0,
                              :pendingPatients => 0,
                              :treatmentArmStatus => treatment_arm[:treatmentArmStatus],
                              :dateCreated => (treatment_arm[:dateCreated]).to_time.to_i,
                              :dateOpened => sorted_status_log.key("OPEN"),
                              :dateClosed => sorted_status_log.key("CLOSED"),
                              :dateSuspended => sorted_status_log.key("SUSPENDED")
      }

      @basic_treatment_arm_array.push(@basic_treatment_arm)

    end

    return @basic_treatment_arm_array

  end

end
