class CreateGoalPlans < ActiveRecord::Migration[8.0]
  def change
    create_table :goal_plans do |t|
      t.string :title, null: false
      t.string :purpose, null: false
      t.string :repeat_term, null: false
      t.time :repeat_time, null: false
      t.string :advice
      t.string :duration, default: "entire_day", null: false
      t.integer :duration_length
      t.string :duration_measure
      t.bigint :creator_id, null: false

      t.timestamps
    end

    add_index :goal_plans, :creator_id
  end
end
