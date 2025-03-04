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

  describe "validations" do
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

  describe "callbacks" do
    it "creates initial goal progresses after creation" do
      goal = create(:goal, user: user, repeat_term: "daily")

      expect(goal.goal_progresses.count).to eq(112) # Ensures 112 progress records are created
      expect(goal.goal_progresses.first.date).to eq(Date.today)
      expect(goal.goal_progresses.last.date).to eq(Date.today + 111.days)
    end
  end

  describe "#next_progress_date" do
    it "returns the correct daily progress date" do
      goal = build(:goal, repeat_term: "daily")
      expect(goal.send(:next_progress_date, 5)).to eq(Date.today + 5.days)
    end

    it "returns the correct weekly progress date" do
      goal = build(:goal, repeat_term: "weekly")
      expect(goal.send(:next_progress_date, 3)).to eq(Date.today + (3 * 7).days)
    end

    it "returns the correct monthly progress date" do
      goal = build(:goal, repeat_term: "monthly")
      expect(goal.send(:next_progress_date, 2)).to eq(Date.today.next_month(2))
    end

    it "returns today's date as a fallback for an invalid repeat_term" do
      goal = build(:goal, repeat_term: "yearly") # Invalid term
      expect(goal.send(:next_progress_date, 2)).to eq(Date.today)
    end
  end

end
