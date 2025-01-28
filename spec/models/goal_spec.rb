require 'rails_helper'

RSpec.describe Goal, type: :model do
  let(:user) { create(:user) } # Assuming you have a user factory

  subject {
    described_class.new(
      title: "Learn Ruby",
      purpose: "Improve programming skills",
      repeat_term: "daily",
      repeat_time: "09:00",
      advice: "Start with basic syntax",
      set_reminder: true,
      reminder_minutes: 30,
      duration: "specific_duration",
      duration_length: 60,
      duration_measure: "minutes",
      graph_type: "dot",
      is_private: true,
      user: user
    )
  }

  it "is valid with valid attributes" do
    expect(subject).to be_valid
  end

  it "is invalid without a title" do
    subject.title = nil
    expect(subject).to_not be_valid
  end

  it "is invalid without a purpose" do
    subject.purpose = nil
    expect(subject).to_not be_valid
  end

  it "is invalid with an invalid repeat_term" do
    subject.repeat_term = "yearly"
    expect(subject).to_not be_valid
  end

  it "is invalid with an invalid duration" do
    subject.duration = "Invalid Duration"
    expect(subject).to_not be_valid
  end

  it "is invalid without a user" do
    subject.user = nil
    expect(subject).to_not be_valid
  end
end
