FactoryBot.define do
  factory :notification do
    user { nil }
    goal { nil }
    title { "MyString" }
    message { "MyText" }
    read_at { "2025-02-25 09:48:54" }
  end
end
