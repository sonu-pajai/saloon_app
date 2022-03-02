class SessionsController < Devise::SessionsController
  respond_to :json

  private

  def respond_with(resource, _opts = {})
    if current_user
      render json: {
        message: 'Logged in sucessfully',
        data: UserSerializer.new(resource, params: {token: "Bearer #{request.env['warden-jwt_auth.token']}"}).serializable_hash[:data][:attributes]
      }, status: :ok
    else
      render json: {
        error: "Authorization Failure"
      }, status: :unauthorized
    end
  end

  def respond_to_on_destroy
    if current_user
      render json: {
        message: "Logged out successfully"
      }, status: :ok
    else
      render json: {
        error: "Couldn't find an active session."
      }, status: :unauthorized
    end
  end
end