class Api::V1::AuthController < ApplicationController

  def login
    @user = User.find_by(email: params[:email])
    if @user&.authenticate(params[:password])
      token = JsonWebToken.encode(user_id: @user.id, email: @user.email)
      render json: { token:, user: { id: @user.id, email: @user.email, name: @user.name } }, status: :ok
    else
      render json: { error: 'Invalid email or password' }, status: :unauthorized
    end
  end
end
