
class PatientController < ApplicationController

  # before_action :authenticate

  def patient_on_treatment_arm
    begin
      if !params[:id].nil?
        treatment_arm_json = TreatmentArmPatient.scan(:scan_filter => {
            "treatment_arm_name_version" => {
                :comparison_operator => "CONTAINS",
                :attribute_value_list => [params[:id]]
            }
        })
      end
      render json: treatment_arm_json
    rescue => error
      standard_error_message(error)
    end
  end


  def patient_assignment
    begin
      @patient_assignment = JSON.parse(request.raw_post)
      @patient_assignment.deep_transform_keys!(&:underscore).symbolize_keys!
      if JSON::Validator.validate(PatientAssignmentValidator.schema, @patient_assignment)
        Aws::Publisher.publish(@patient_assignment)
        render json: {:status => "SUCCESS"}, :status => 200
      else
        JSON::Validator.validate!(PatientAssignmentValidator.schema, @patient_assignment)
      end
    rescue => error
      standard_error_message(error)
    end
  end

  private
  def standard_error_message(error)
    logger.error error.message
    render :json => {:status => "Failure" ,:error => error.message}, :status => 500
  end

end