class GraphDataController < ApplicationController

  # before_action :authenticate:

  def patient_status_count
    begin
      if !params[:id].nil?
        pie_data = StatusPieData.where(:_id => params[:id])
      else
        pie_data = StatusPieData.all
      end
      render json: pie_data
    rescue => error
      standard_error_message(error)
    end
  end

  def patient_disease_data
    begin
      if !params[:id].nil?
        disease_data = DiseasePieData.where(:_id => params[:id])
      else
        disease_data = DiseasePieData.all
      end
      render json: disease_data
    rescue => error
      standard_error_message(error)
    end
  end


  private

  def standard_error_message(error)
    logger.error(error.message)
  end

end