class CreateGoalProgresses < ActiveRecord::Migration[8.0]
  def change
    create_table :goal_progresses do |t|
      t.references :goal, null: false, foreign_key: true
      t.date :date, null: false
      t.boolean :completed, default: false, null: false
      t.datetime :checked_at
      t.integer :current_streak, default: 0  # Tracks current streak
      t.integer :longest_streak, default: 0  # Tracks longest streak

      t.timestamps
    end
  end
end
