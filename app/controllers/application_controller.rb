class ApplicationController < ActionController::Base
  include Knock::Authenticable

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  # protect_from_forgery with: :exception
  rescue_from Aws::DynamoDB::Errors::ResourceNotFoundException, with: :resource_not_found_exception
  rescue_from Seahorse::Client::NetworkingError, with: :no_db_connection_exception
  rescue_from ActionController::RoutingError, with: lambda { |exception| render_error(:bad_request, exception) }

  protected

  def render_error(status, exception)
    logger.error status.to_s +  " " + exception.to_s
    respond_to do |format|
      format.all { head status}
    end
  end

  def resource_not_found_exceptions
    render json: { message: "One of the Tables doesn't exist, Please create the table by restarting the TreatmentArmProcessorAPI server" }, status: 400
  end

  def no_db_connection_exception
    render json: { message: "Database is not ACTIVE" }, status: 502
  end
end
