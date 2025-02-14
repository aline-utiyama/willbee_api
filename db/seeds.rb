# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# Clear existing data to prevent duplicates
User.destroy_all
Goal.destroy_all
GoalPlan.destroy_all

# Create Users
user = User.create!(
  name: "Test",
  surname: "User",
  username: "testuser",
  email: "testuser@example.com",
  password: "password123",
  password_confirmation: "password123"
)

# Create a user to associate with goal plans
plan_creator = User.create!(
  name: "Mary",
  surname: "Jane",
  username: "maryjane",
  email: "maryjane@example.com",
  password: "password123",
  password_confirmation: "password123"
)


puts "✅ Created #{User.count} users"

# Create Goals
10.times do |i|
  Goal.create!(
    title: "Entire Day Goal #{i + 1}",
    purpose: "Purpose for goal #{i + 1}",
    repeat_term: "daily",
    repeat_time: Time.now.strftime("%H:%M"), # Example: "09:00"
    advice: "This is some AI-generated advice for goal #{i + 1}",
    set_reminder: true,
    reminder_minutes: [10, 15, 30, 60].sample,
    duration: "entire_day",
    duration_length: nil,
    duration_measure: nil,
    graph_type: "dot",
    is_private: true,
    user: user # Assign a random user
  )
end

10.times do |i|
  Goal.create!(
    title: "Specific time Goal  #{i + 1}",
    purpose: "Purpose for goal #{i + 1}",
    repeat_term: "daily",
    repeat_time: Time.now.strftime("%H:%M"), # Example: "09:00"
    advice: "This is some AI-generated advice for goal #{i + 1}",
    set_reminder: true,
    reminder_minutes: [10, 15, 30, 60].sample,
    duration: "specific_duration",
    duration_length: [30, 60, 120].sample,
    duration_measure: ["minutes", "meters", "pages"].sample,
    graph_type: "bar",
    is_private: true,
    user: user # Assign a random user
  )
end

puts "✅ Created #{Goal.count} goals"

# Create Goal Plans
goal_plans = [
  { title: "Morning Routine", purpose: "Start the day fresh", repeat_term: "daily", repeat_time: "06:30", advice: "Drink water first", duration: "specific_duration", duration_length: 30, duration_measure: "minutes", creator: user },
  { title: "Read a Book", purpose: "Improve knowledge", repeat_term: "daily", repeat_time: "20:00", advice: "Start with 10 pages", duration: "specific_duration", duration_length: 60, duration_measure: "minutes", creator: user },
  { title: "Workout", purpose: "Stay fit", repeat_term: "daily", repeat_time: "18:00", advice: "Focus on strength", duration: "entire_day", creator: user },
  { title: "Stop eating Sugar", purpose: "Stay healthier", repeat_term: "daily", repeat_time: "22:00", advice: "Focus on your health", duration: "entire_day", creator: user }
]

goal_plans.each do |plan|
  GoalPlan.create!(plan)
end

puts "✅ Seeded #{GoalPlan.count} goal plans!"