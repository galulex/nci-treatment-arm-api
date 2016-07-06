
class TreatmentarmController < ApplicationController
  # before_action :authenticate

  def new_treatment_arm
    begin
      @treatment_arm = JSON.parse(request.raw_post)
      @treatment_arm.deep_transform_keys!(&:underscore).symbolize_keys!
      if JSON::Validator.validate(TreatmentArmValidator.schema, @treatment_arm)
        Aws::Publisher.publish(@treatment_arm)
        render json: {:status => "SUCCESS"}, :status => 200
      else
        JSON::Validator.validate!(TreatmentArmValidator.schema, @treatment_arm)
      end
    rescue => error
      standard_error_message(error)
    end
  end

  def treatment_arms
    begin
      render json: TreatmentArm.scan({}).collect { |data| data.to_h }.sort_by{| ta | ta[:date_created]}.reverse
    rescue => error
      standard_error_message(error)
    end
  end

  def treatment_arm
    begin
      treatment_arm_json = TreatmentArm.find_by(params[:id], params[:stratum_id], params[:version])
                               .sort_by{| ta | ta[:date_created]}
                               .reverse.uniq { | arm | arm[:name] && arm[:stratum_id] }
      render json: treatment_arm_json
    rescue => error
      standard_error_message(error)
    end
  end

  def treatment_arm_versions
    begin
      render nothing: true
    rescue => error
      standard_error_message(error)
    end
  end

  def basic_treatment_arms
    begin
      basic_treatment_arm_json = TreatmentArm.find_basic_treatment_arm_by(params[:id])
      render json: basic_treatment_arm_json
    rescue => error
      standard_error_message(error)
    end
  end

  private

  def standard_error_message(error)
    logger.error error.message
    render :json => {:status => "FAILURE" ,:error => error.message}, :status => 500
  end

end