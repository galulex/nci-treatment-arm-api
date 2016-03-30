class VersionController < ApplicationController

  def version
    begin
      render json: TreatmentArmRestfulApi::Application.VERSION
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