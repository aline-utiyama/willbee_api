class Api::V1::GoalsController < ApplicationController
  before_action :authenticate_user!

  # GET /api/v1/goals
  def index
    @goals = current_user.goals
    if @goals
      render json: @goals
    else
      render json: { error: "Goals not found" }, status: :not_found
    end
  end

  # POST /api/v1/goals
  def create
    @goal = current_user.goals.new(goal_params)
    if @goal.save
      render json: @goal, status: :created
    else
      render json: { errors: @goal.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # GET /api/v1/goals/:id
  def show
    @goal = current_user.goals.find_by(id: params[:id])
    if @goal
      render json: @goal
    else
      render json: { error: "Goal not found" }, status: :not_found
    end
  end

  # PUT /api/v1/goals/:id
  def update
    @goal = current_user.goals.find_by(id: params[:id])
    if @goal.update(goal_params)
      render json: @goal
    else
      render json: { errors: @goal.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # DELETE /api/v1/goals/:id
  def destroy
    @goal = current_user.goals.find_by(id: params[:id])
    if @goal
      @goal.destroy
      head :no_content
    else
      render json: { error: "Goal not found" }, status: :not_found
    end
  end

  private

  def set_goal
    @goal = current_user.goals.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Goal not found" }, status: :not_found
  end

  def goal_params
    params.require(:goal).permit(
      :title, :purpose, :repeat_term, :repeat_time, :advice, :set_reminder, 
      :reminder_minutes, :duration, :duration_length, :duration_measure, 
      :graph_type, :is_private
    )
  end
end
