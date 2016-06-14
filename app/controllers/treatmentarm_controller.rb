
class TreatmentarmController < ApplicationController
  # before_action :authenticate


  def new_treatment_arm
    begin
      @treatment_arm = JSON.parse(request.raw_post)
      if JSON::Validator.validate(TreatmentArmValidator.schema, @treatment_arm)
        @treatment_arm.deep_transform_keys!(&:underscore).symbolize_keys!
        treatment_arm_model = TreatmentArm.new.from_json(TreatmentArm.new.convert_models(@treatment_arm).to_json)
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
      render json: TreatmentArm.scan({}).collect { |data| data.to_h }
    rescue => error
      standard_error_message(error)
    end
  end

  def treatment_arm
    begin
      if !params[:id].nil? && params[:version].nil?
        treatment_arm_json = TreatmentArm.scan(:scan_filter => {
            "name" => {
                :comparison_operator => "EQ",
                :attribute_value_list => [params[:id]]
            }
        }).collect { |data| data.to_h }
      elsif !params[:id].nil? && !params[:version].nil?
        treatment_arm_json = TreatmentArm.find(:name => params[:id], :version => params[:version]).to_h
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
      basic_treatment_arm_json = TreatmentArm.scan({:attributes_to_get => ["name",
                                                                             "current_patients",
                                                                             "former_patients",
                                                                             "not_enrolled_patients",
                                                                             "pending_patients",
                                                                             "date_opened",
                                                                             "treatment_arm_status",
                                                                             "date_opened","date_created"]}).collect { |data| data.to_h }
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