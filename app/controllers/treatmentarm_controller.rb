
class TreatmentarmController < ApplicationController
  before_action :authenticate


  def new_treatment_arm
    begin
      @treatment_arm = JSON.parse(request.raw_post)
      @treatment_arm.deep_transform_keys!(&:underscore).symbolize_keys!
      treatment_arm_model = TreatmentArm.new.from_json(TreatmentArm.new.convert_models(@treatment_arm).to_json)
      if treatment_arm_model.valid?
        Aws::Publisher.publish(@treatment_arm)
        render json: {:status => "SUCCESS"}, :status => 200
      else
        render json: {:status => "FAILURE", :message => "Validation failed.  Please check all required fields are present"}, :status => 400
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
      if !params[:id].nil?
        basic_treatment_arm_json = BasicTreatmentArm.find(treatment_arm_id: params[:id]).to_h
      else
        basic_treatment_arm_json = BasicTreatmentArm.scan({}).collect { |data| data.to_h }
      end
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