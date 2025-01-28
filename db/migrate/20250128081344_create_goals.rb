class CreateGoals < ActiveRecord::Migration[8.0]
  def change
    create_table :goals do |t|
      t.string :title, null: false
      t.string :purpose, null: false
      t.string :repeat_term, null: false # e.g., "daily", "weekly", "monthly"
      t.time :repeat_time, null: false # Store time for repeat (e.g., "9:00 AM")
      t.string :advice
      t.boolean :set_reminder, default: false
      t.integer :reminder_minutes # The number of minutes for the reminder
      t.string :duration, null: false, default: "entire_day" # Only ["entire_day", "specific_duration"]
      t.integer :duration_length # If duration is "Specific Duration", store length (e.g., 60 for minutes)
      t.string :duration_measure # If specific duration, store unit like "minutes"
      t.string :graph_type, null: false, default: "dot" # Only ["dot", "bar"]
      t.boolean :is_private, default: true
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
