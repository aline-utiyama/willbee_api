FactoryBot.define do
  factory :goal_progress do
    association :goal
    date { Date.current }
    completed { false }
    checked_at { nil }
    current_streak { 0 }
    longest_streak { 0 }
  end
end