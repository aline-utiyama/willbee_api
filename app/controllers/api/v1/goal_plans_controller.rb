class Api::V1::GoalPlansController < ApplicationController
  before_action :authenticate_user!
  before_action :set_goal_plan, only: [:show, :update, :destroy]

  # GET /api/v1/goal_plans
  def index
    if params[:category].present?
      @goal_plans = GoalPlan.where(category: params[:category])
    else
      @goal_plans = GoalPlan.all
    end

    render json: @goal_plans
  end

  # POST /api/v1/goal_plans
  def create
    @goal_plan = current_user.goal_plans.new(goal_plan_params)
    if @goal_plan.save
      render json: @goal_plan, status: :created
    else
      render json: { errors: @goal_plan.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # GET /api/v1/goal_plans/:id
  def show
    @goal_plan = current_user.goal_plans.find_by(id: params[:id])
    if @goal_plan
      render json: @goal_plan.as_json(include: :creator)
    else
      render json: { error: "Goal Plan not found" }, status: :not_found
    end
  end

  # PUT /api/v1/goal_plans/:id
  def update
    if @goal_plan.creator == current_user && @goal_plan.update(goal_plan_params)
      render json: @goal_plan
    else
      render json: { errors: @goal_plan.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # DELETE /api/v1/goal_plans/:id
  def destroy
    if @goal_plan.creator == current_user
      @goal_plan.destroy
      head :no_content
    else
      render json: { error: "You can only delete your own goal plans." }, status: :forbidden
    end
  end

  private

  def set_goal_plan
    @goal_plan = GoalPlan.find_by(id: params[:id])
    render json: { error: "Goal Plan not found" }, status: :not_found unless @goal_plan
  end

  def goal_plan_params
    params.require(:goal_plan).permit(:title, :purpose, :repeat_term, :repeat_time, :advice, :duration, :duration_length, :duration_measure, :category)
  end
end
