class ApplicationController < ActionController::Base
  include Knock::Authenticable

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  # protect_from_forgery with: :exception
  rescue_from Aws::DynamoDB::Errors::ResourceNotFoundException, with: :no_resource_found_exception

  protected

  def no_resource_found_exception
    render json: { message: "TreatmentArm table doesn't exist, Please create the table by restarting the TreatmentArmProcessorAPI server" }, status: 400
  end
end
