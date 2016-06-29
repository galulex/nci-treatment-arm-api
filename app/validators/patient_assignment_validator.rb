
  module PatientAssignmentValidator

    class << self

      attr_reader :schema

      def schema
        @schema = {
            "type" => "object",
            "required" => ["date_assigned","treatment_arm", "patient_assignment_status","step_number"],
            "properties" => {
                "date_assigned" => {"type" => "string", "minLength" => 1},
                "surgical_event_id" => {"anyOf" => [{"type" => "string"}, {"type" => "number"}, {"type" => "null"}]},
                "treatment_arm" => {"type" => "object"},
                "patient_assignment_status" => {"type" => "object"},
                "patient_assignment_logic" => {"type" => "array"},
                "step_number" => {"type" => "string"},
                "patient_assignment_messages" => {"type" => "array"}
            }
        }
      end
    end


    # private Date dateAssigned;
    # private String surgicalEventId;
    # private TreatmentArm treatmentArm;
    # private PatientAssignmentStatus patientAssignmentStatus;
    # private List<PatientAssignmentLogic> patientAssignmentLogic;
    # private String patientAssignmentStatusMessage;
    # private String stepNumber;
    # private List<PatientAssignmentMessage> patientAssignmentMessages;


  end