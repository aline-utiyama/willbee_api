require 'rails_helper'

RSpec.describe GoalPlan, type: :model do
  let(:user) { create(:user) } # Assuming you have a user factory

  subject {
    described_class.new(
      title: "Morning Workout",
      purpose: "Stay fit and healthy",
      repeat_term: "daily",
      repeat_time: "09:00",
      advice: "Start with stretching",
      duration: "specific_duration",
      duration_length: 30,
      duration_measure: "minutes",
      creator: user
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

  it "is invalid without a creator" do
    subject.creator = nil
    expect(subject).to_not be_valid
  end
end
