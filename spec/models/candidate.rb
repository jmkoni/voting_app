require "rails_helper"

describe Candidate, type: :model do
  after(:each) do
    Candidate.destroy_all
  end

  describe "validations" do
    it "should validate presence of name" do
      candidate = Candidate.new
      expect(candidate.valid?).to eq(false)
      expect(candidate.errors.messages[:name]).to eq(["can't be blank"])
    end
  end

  describe "add_new_candidate" do
    it "should create a new candidate if there are no similar candidates" do
      expect(Candidate.count).to eq(0)
      Candidate.add_new_candidate("Test Candidate")
      expect(Candidate.count).to eq(1)
    end

    it "should return the closest match if there is one" do
      Candidate.create(name: "Ash Ketchum", vote_count: 1)
      Candidate.create(name: "Princess Peach", vote_count: 1)
      expect(Candidate.count).to eq(2)
      expect(Candidate.add_new_candidate("Ash T. Ketchum").name).to eq("Ash Ketchum")
      expect(Candidate.count).to eq(2)
    end
  end

  describe "closest_match" do
    it "should return nil if there are no candidates" do
      expect(Candidate.closest_match("Test Candidate")).to eq(nil)
    end

    it "should return nil if there are no similar candidates" do
      Candidate.create(name: "Ash Ketchum", vote_count: 1)
      expect(Candidate.closest_match("Princess Peach")).to eq(nil)
    end
  end

  describe "not_more_than_ten" do
    it "should return an error if there are already 10 candidates" do
      10.times do |i|
        Candidate.create(name: Faker::Name.name + " #{i}", vote_count: 1)
      end
      candidate = Candidate.new(name: Faker::Name.name)
      expect(candidate.valid?).to eq(false)
      expect(candidate.errors.messages[:candidate]).to eq(["can only have 10 total candidates"])
    end
  end
end
