# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

require 'open-uri'

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

user_img = OpenURI.open_uri("https://i.pravatar.cc/40?img=5")
user.image.attach(io: user_img, filename: 'nes.png', content_type: 'image/png')
user.save

# Create a user to associate with goal plans
plan_creator = User.create!(
  name: "Mary",
  surname: "Jane",
  username: "maryjane",
  email: "maryjane@example.com",
  password: "password123",
  password_confirmation: "password123"
)

plan_creator_img = OpenURI.open_uri("https://i.pravatar.cc/40?img=1")
plan_creator.image.attach(io: plan_creator_img, filename: 'nes.png', content_type: 'image/png')
plan_creator.save


puts "✅ Created #{User.count} users"

# Create Goals
2.times do |i|
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

2.times do |i|
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
  # Personal Growth
  { title: "Morning Meditation", purpose: "Cultivate mindfulness and reduce stress for a fresh start.", category: "Personal Growth", repeat_term: "daily", repeat_time: "07:00", advice: "Focus on deep breathing", duration: "specific_duration", duration_length: 15, duration_measure: "minutes", creator: plan_creator },
  { title: "Journaling", purpose: "Reflect on daily experiences to boost self-awareness.", category: "Personal Growth", repeat_term: "daily", repeat_time: "21:00", advice: "Write at least 3 sentences", duration: "specific_duration", duration_length: 10, duration_measure: "minutes", creator: plan_creator },
  { title: "Learn a New Skill", purpose: "Enhance personal growth by practicing a new ability.", category: "Personal Growth", repeat_term: "daily", repeat_time: "19:00", advice: "Practice consistently", duration: "specific_duration", duration_length: 60, duration_measure: "minutes", creator: plan_creator },

  # Fitness
  { title: "Morning Stretch", purpose: "Improve flexibility and prevent injuries with daily stretching.", category: "Fitness", repeat_term: "daily", repeat_time: "06:30", advice: "Hold each stretch for 30 seconds", duration: "specific_duration", duration_length: 10, duration_measure: "minutes", creator: plan_creator },
  { title: "Cardio Workout", purpose: "Increase stamina and heart health through regular cardio.", category: "Fitness", repeat_term: "daily", repeat_time: "17:00", advice: "Start with light jogging", duration: "specific_duration", duration_length: 45, duration_measure: "minutes", creator: plan_creator },
  { title: "Strength Training", purpose: "Build muscle and boost endurance with consistent workouts.", category: "Fitness", repeat_term: "daily", repeat_time: "18:00", advice: "Increase weights gradually", duration: "specific_duration", duration_length: 40, duration_measure: "minutes", creator: plan_creator },

  # Sports
  { title: "Play Soccer", purpose: "Improve agility, teamwork, and overall physical fitness.", category: "Sports", repeat_term: "daily", repeat_time: "17:30", advice: "Warm up before playing", duration: "specific_duration", duration_length: 90, duration_measure: "minutes", creator: plan_creator },
  { title: "Tennis Practice", purpose: "Enhance coordination, reaction speed, and precision.", category: "Sports", repeat_term: "daily", repeat_time: "16:00", advice: "Focus on footwork", duration: "specific_duration", duration_length: 60, duration_measure: "minutes", creator: plan_creator },
  { title: "Swimming", purpose: "Strengthen muscles and improve endurance with low impact.", category: "Sports", repeat_term: "daily", repeat_time: "15:00", advice: "Improve breathing techniques", duration: "specific_duration", duration_length: 45, duration_measure: "minutes", creator: plan_creator },

  # Reading
  { title: "Read a Book", purpose: "Expand knowledge and enhance vocabulary through reading.", category: "Reading", repeat_term: "daily", repeat_time: "20:30", advice: "Read at least 10 pages", duration: "specific_duration", duration_length: 30, duration_measure: "minutes", creator: plan_creator },
  { title: "Read News Articles", purpose: "Stay updated on global events and develop critical thinking.", category: "Reading", repeat_term: "daily", repeat_time: "08:00", advice: "Use trusted sources", duration: "specific_duration", duration_length: 15, duration_measure: "minutes", creator: plan_creator },
  { title: "Listen to Audiobooks", purpose: "Learn new concepts while commuting or multitasking.", category: "Reading", repeat_term: "daily", repeat_time: "19:30", advice: "Pick educational content", duration: "specific_duration", duration_length: 60, duration_measure: "minutes", creator: plan_creator },

  # Music
  { title: "Practice an Instrument", purpose: "Improve musical skills and build discipline through practice.", category: "Music", repeat_term: "daily", repeat_time: "17:00", advice: "Focus on technique", duration: "specific_duration", duration_length: 30, duration_measure: "minutes", creator: plan_creator },
  { title: "Learn Music Theory", purpose: "Understand the structure behind music for better performance.", category: "Music", repeat_term: "daily", repeat_time: "18:30", advice: "Start with basic notes", duration: "specific_duration", duration_length: 45, duration_measure: "minutes", creator: plan_creator },
  { title: "Compose a Song", purpose: "Boost creativity and develop songwriting skills daily.", category: "Music", repeat_term: "daily", repeat_time: "20:00", advice: "Experiment with melodies", duration: "specific_duration", duration_length: 120, duration_measure: "minutes", creator: plan_creator },

  # Health
  { title: "Stay Hydrated", purpose: "Maintain energy levels and support overall well-being.", category: "Health", repeat_term: "daily", repeat_time: "09:00", advice: "Drink at least 2 liters of water", duration: "entire_day", creator: plan_creator },
  { title: "Eat a Balanced Diet", purpose: "Ensure proper nutrition for long-term health benefits.", category: "Health", repeat_term: "daily", repeat_time: "12:00", advice: "Include more vegetables", duration: "entire_day", creator: plan_creator },
  { title: "Improve Sleep Routine", purpose: "Enhance focus and recovery by improving sleep quality.", category: "Health", repeat_term: "daily", repeat_time: "22:30", advice: "Avoid screens before bed", duration: "entire_day", creator: plan_creator },

  # Career
  { title: "Update Resume", purpose: "Keep career documents updated for new opportunities.", category: "Career", repeat_term: "daily", repeat_time: "10:00", advice: "Highlight recent achievements", duration: "specific_duration", duration_length: 60, duration_measure: "minutes", creator: plan_creator },
  { title: "Network with Professionals", purpose: "Expand career connections and discover new opportunities.", category: "Career", repeat_term: "daily", repeat_time: "14:00", advice: "Engage on LinkedIn", duration: "specific_duration", duration_length: 30, duration_measure: "minutes", creator: plan_creator },
  { title: "Learn a New Skill", purpose: "Develop abilities to enhance career growth and success.", category: "Career", repeat_term: "daily", repeat_time: "19:00", advice: "Take online courses", duration: "specific_duration", duration_length: 90, duration_measure: "minutes", creator: plan_creator }
]

goal_plans.each do |plan|
  plan = GoalPlan.create!(plan)
  file = OpenURI.open_uri('https://picsum.photos/200')
  plan.image.attach(io: file, filename: 'nes.png', content_type: 'image/png')
  plan.save
end

puts "✅ Seeded #{GoalPlan.count} goal plans!"