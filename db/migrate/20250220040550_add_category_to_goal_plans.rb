class AddCategoryToGoalPlans < ActiveRecord::Migration[8.0]
  def change
    add_column :goal_plans, :category, :string, null: false, default: ""
  end
end
