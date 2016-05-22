class GraphDataController < ApplicationController

  before_action :authenticate

  def patient_status_count
    begin
      if does_params_define_id(params)
        pie_data = StatusPieData.find(:id => params[:id]).to_h
      else
        pie_data = StatusPieData.scan({}).collect { |data| data.to_h }
      end
      render json: pie_data
    rescue => error
      standard_error_message(error)
    end
  end

  def patient_disease_data
    begin
      render json: does_params_define_id(params) ? DiseasePieData.where(:_id => params[:id]) : DiseasePieData.all
    rescue => error
      standard_error_message(error)
    end
  end


  private

  def does_params_define_id(params)
    !params[:id].nil?
  end

  def standard_error_message(error)
    logger.error(error.message)
    render :json => error.to_json, :status => 500
  end

end