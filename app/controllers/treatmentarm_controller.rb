
class TreatmentarmController < ApplicationController

  # before_action :authenticate

  def new_treatment_arm
    begin
      @treatment_arm = JSON.parse(request.raw_post)
      @treatment_arm.deep_transform_keys!(&:underscore)
      Aws::Publisher.publish(@treatment_arm)
      render json: {:status => "Success"}, :status => 200
    rescue => error
      standard_error_message(error)
    end
  end

  def treatment_arms
    begin
      render json: TreatmentArm.all
    rescue => error
      standard_error_message(error)
    end
  end

  def treatment_arm
    begin
      if !params[:id].nil? && params[:version].nil?
        treatment_arm_json = TreatmentArm.where(:name => params[:id]).first
      elsif !params[:id].nil? && !params[:version].nil?
        treatment_arm_json = TreatmentArm.where(:name => params[:id], :version => params[:version]).first
      end
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
      if !params[:id].nil?
        basic_treatment_arm_json = BasicTreatmentArm.find(treatment_arm_id: params[:id])
      else
        basic_treatment_arm_json = BasicTreatmentArm.scan({})
      end
      render json: basic_treatment_arm_json
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