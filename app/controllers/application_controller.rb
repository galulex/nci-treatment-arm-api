class ApplicationController < ActionController::Base
  include Knock::Authenticable

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  # protect_from_forgery with: :exception
  rescue_from CanCan::AccessDenied, with: ->(exception) { render_error_with_message(:unauthorized, exception) }
  rescue_from NameError, with: ->(exception) { render_error(:internal_server_error, exception) }

  protected

  def render_error(status, exception)
    logger.error status.to_s +  " " + exception.to_s
    respond_to do |format|
      format.all { head status, message: exception.message}
    end
  end

  def render_error_with_message(status, exception)
    logger.error status.to_s +  " " + exception.to_s
    render json: { message: exception.message }, status: status
  end

  def standard_error_message(error)
    logger.error "#{error.message} :: #{error.backtrace}"
    render json: { message: error.message }, status: 500
  end
end
