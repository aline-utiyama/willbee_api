FactoryBot.define do
  factory :goal do
    title { "Learn Ruby" }
    purpose { "Improve programming skills" }
    repeat_term { "daily" }
    repeat_time { "09:00" }
    advice { "Start with basic syntax" }
    set_reminder { true }
    reminder_minutes { 30 }
    duration { "specific_duration" }
    duration_length { 60 }
    duration_measure { "minutes" }
    graph_type { "dot" }
    is_private { true }

    association :user # Assuming Goal belongs to User
  end
end