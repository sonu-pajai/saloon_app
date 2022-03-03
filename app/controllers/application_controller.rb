class ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session

  before_action :configure_permitted_parameters, if: :devise_controller?

  def authenticate_admin!
    invalid_authentication unless current_user.admin?
  end

  protected

  def invalid_authentication
    render_api_error("Access Denied", 403) and return
  end

  def render_api_error(error, status_code)
    render json: {errors: error}, status: 403
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :phone_number])
  end
end
