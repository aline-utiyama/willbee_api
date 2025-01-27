class Api::V1::UsersController < ApplicationController
  def create
    @user = User.new(user_params)
    Rails.logger.debug "Received params: #{params.inspect}"

    if @user.save
      render json: { message: "User created successfully", user: @user }, status: :created
    else
      render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
      Rails.logger.debug "Received params errorr: #{@user.errors.full_messages}"
    end
  end

  def update
    @user = User.find_by(id: params[:id])
    Rails.logger.debug "Received params: #{params.inspect}"
    

    if @user.nil?
      render json: { message: "User not found" }, status: :not_found
    elsif @user.update(user_basic_params)
      render json: { message: "User updated successfully", user: @user }, status: :ok
    else
      Rails.logger.debug "Received params errorr: #{@user.errors.full_messages}"
      render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @user = User.find_by(id: params[:id])

    if @user.nil?
      render json: { message: "User not found" }, status: :not_found
    else
      @user.destroy
      render json: { message: "User deleted successfully" }, status: :ok
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :surname, :email, :username, :password, :password_confirmation)
  end

  def user_basic_params
    params.require(:user).permit(:name, :surname, :username)
  end
end
