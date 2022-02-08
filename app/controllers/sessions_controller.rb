class SessionsController < Devise::SessionsController
  respond_to :json

  private

  def respond_with(resource, _opts = {})
    render json: {
      auth: {
        token: "Bearer #{request.env['warden-jwt_auth.token']}",
        timestamp: Time.now.strftime("%Y-%m-%dT%H:%M:%S.%L%z")
      }
    }, status: :ok
  end

  def respond_to_on_destroy
    log_out_success && return if current_user

    log_out_failure
  end

  def log_out_success
    render json: { message: "You are logged out Successful." }, status: :ok
  end

  def log_out_failure
    render json: { message: " Logged out Unsuccessful."}, status: :unauthorized
  end
end