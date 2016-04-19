require 'date'
require 'basic_treatment_arm'

class BasicTreatmentArmJob

  @queue = :treatment_arm

  def self.perform(treatment_arm)
    begin
      treatment_arm = treatment_arm.symbolize_keys
      if BasicTreatmentArm.where(:_id => treatment_arm[:id]).exists?
        update(treatment_arm)
      else
        insert(treatment_arm)
      end
    rescue => error
      Resque.logger.error error.message
    end
  end


  def self.update(treatment_arm)

  end

  def self.insert(treatment_arm)
    sorted_status_log = !treatment_arm[:statusLog].blank? ? treatment_arm[:statusLog].sort_hash_descending  : {}
    basic_treatment_arm = { :_id => treatment_arm[:id],
                            :treatment_arm_name => treatment_arm[:name],
                            :current_patients => treatment_arm[:numPatientsAssigned],
                            :former_patients => 0,
                            :not_enrolled_patients => 0,
                            :pending_patients => 0,
                            :treatment_arm_status => treatment_arm[:treatment_arm_status],
                            :date_created => !treatment_arm[:date_created].blank? ? (treatment_arm[:date_created]).to_time.to_i : nil,
                            :date_opened => sorted_status_log.key("OPEN"),
                            :date_closed => sorted_status_log.key("CLOSED"),
                            :date_suspended => sorted_status_log.key("SUSPENDED")
    }
    ba = BasicTreatmentArm.new(basic_treatment_arm)
    ba.save
  end

end
