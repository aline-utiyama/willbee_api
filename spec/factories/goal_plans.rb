FactoryBot.define do
  factory :goal_plan do
    title { "Learn Ruby" }
    purpose { "Improve programming skills" }
    repeat_term { "daily" }
    repeat_time { "09:00" }
    advice { "Start with basic syntax" }
    duration { "specific_duration" }
    duration_length { 60 }
    duration_measure { "minutes" }
    creator_id { "" }
  end
end
