class RegistrationsController < Devise::RegistrationsController
  respond_to :json

  private

  def respond_with(resource, _opts = {})
    register_success && return if resource.persisted?

    register_failed
  end

  def register_success
    render json: {
        message: 'Signed up sucessfully.',
        data: UserSerializer.new(resource, params: {token: "Bearer #{request.env['warden-jwt_auth.token']}"}).serializable_hash[:data][:attributes]
      }, status: :ok
  end

  def register_failed
    render json: { message: resource.errors.full_messages.join(", ") }
  end
end