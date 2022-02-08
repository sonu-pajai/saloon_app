class UserSerializer
  include FastJsonapi::ObjectSerializer
  attributes :email

  attribute :token do |object, params|
    params[:token]
  end

  attribute :timestamp do |object, params|
    Time.now.strftime("%Y-%m-%dT%H:%M:%S.%L%z")
  end

end
