
require 'treatment_arm'

class TreatmentarmController < ApplicationController

  # before_action :authenticate

  def new_treatment_arm
    begin
      @treatmentArm = JSON.parse(request.raw_post)
      treatmentArmModel = TreatmentArm.new @treatmentArm
      treatmentArmModel.save
      render nothing: true
    rescue => error
      standard_error_message(error)
    end

  end

  #done needs rspec test
  def approve_treatment_arm
    begin
      if !params[:id].nil?
        if TreatmentArm.new.validate_eligible_for_approval(params[:id])
          treatment_arm = TreatmentArm.where(:_id => params[:id]).first
          treatment_arm.set(treatmentArmStatus: "READY")
          treatment_arm.statusLog.store(Time.now.to_i, "READY")
          treatment_arm.save!
        end
      end
      render nothing: true
    rescue => error
      standard_error_message(error)
    end
  end

  def ecog_treatment_arm_list
    begin
      render nothing: true
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
        treatmentArmJson = TreatmentArm.where(_id: params[:id])
      elsif !params[:id].nil? && !params[:version].nil?
        treatmentArmJson = TreatmentArm.where(_id: params[:id]).in(version: params[:version])
      end
      render json: treatmentArmJson
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
      render json: BasicTreatmentArmProcessor.new.create_treatment_arm_hash
    rescue => error
      standard_error_message(error)
    end
  end

  private

  def standard_error_message(error)
    logger.error error.message
    status 500
  end

end