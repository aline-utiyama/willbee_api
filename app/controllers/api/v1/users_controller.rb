class Api::V1::UsersController < ApplicationController
  before_action :authenticate_user!, except: [ :create ]

  def show
    if current_user
      render json: { user: current_user.as_json(only: [ :id, :name, :surname, :username, :email ], methods: [:image_url]) }, status: :ok
    else
      render json: { error: "User not found" }, status: :not_found
    end
  end

  def create
    @user = User.new(user_params)

    if @user.save
      render json: { message: "User created successfully", user: @user }, status: :created
    else
      render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    @user = User.find_by(id: params[:id])

    if @user.nil?
      render json: { message: "User not found" }, status: :not_found
    elsif @user.update(user_params)
      render json: { message: "User updated successfully", user: @user }, status: :ok
    else
      render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :surname, :email, :username, :password, :password_confirmation)
  end
end
