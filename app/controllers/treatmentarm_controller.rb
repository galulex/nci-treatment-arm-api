
class TreatmentarmController < ApplicationController
  include HTTParty

  before_action :authenticate, if: "Rails.env.production?"
  before_action :update_ta_status, only: [:treatment_arm, :treatment_arms, :basic_treatment_arms, :treatment_arm_versions]
  attr_accessor :cog_treatment_arms

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
      data = TreatmentArm.find_by(params[:id], params[:stratum_id], params[:version])
            .sort_by{| ta | ta[:date_created]}
            .reverse
      data.each do | ta |
        # p ta[:name]
        # # p @cog_treatment_arms
      end
      render json: TreatmentArm.find_by(params[:id], params[:stratum_id], params[:version])
                       .sort_by{| ta | ta[:date_created]}
                       .reverse
    rescue => error
      standard_error_message(error)
    end
  end

  def treatment_arm
    begin
      render json: TreatmentArm.find_by(params[:id], params[:stratum_id], params[:version])
                       .sort_by{| ta | ta[:date_created]}
                       .reverse.first
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

  def update_ta_status
    begin
      results = HTTParty.get(ENV["cog_url"] + ENV["cog_treatment_arms"])
      @cog_treatment_arms = JSON.parse(results.body).deep_transform_keys!(&:underscore).symbolize_keys![:treatment_arms]
    rescue => error
      logger.error "Failed to connect to cog service with error #{error.message}"
    end
  end

end