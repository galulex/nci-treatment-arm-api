
class TreatmentarmController < ApplicationController

  # before_action :authenticate

  def new_treatment_arm
    begin
      @treatment_arm = JSON.parse(request.raw_post)
      @treatment_arm.deep_transform_keys!(&:underscore).symbolize_keys!
      @treatment_arm[:treatment_arm_id] = @treatment_arm[:_id]
      @treatment_arm.except!(:_id)
      Publisher.publish("treatment_arm", @treatment_arm)
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
          treatment_arm.set(treatment_arm_status: "READY")
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
        basic_treatment_arm_json = BasicTreatmentArm.where(_id: params[:id])
      else
        basic_treatment_arm_json = BasicTreatmentArm.all
      end
      render json: basic_treatment_arm_json
    rescue => error
      standard_error_message(error)
    end
  end

  def variant_report
    begin
      render nothing: true
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