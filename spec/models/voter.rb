require "rails_helper"

describe Voter, type: :model do
  describe "validations" do
    it "should validate presence of email" do
      voter = Voter.new(zip_code: "12345")
      expect(voter.valid?).to eq(false)
      expect(voter.errors.messages[:email]).to include("can't be blank")
    end

    it "should validate format of email" do
      voter = Voter.new(email: "test", zip_code: "12345")
      expect(voter.valid?).to eq(false)
      expect(voter.errors.messages[:email]).to eq(["is invalid"])
    end

    it "should validate presence of zip code" do
      voter = Voter.new(email: "test@test.com")
      expect(voter.valid?).to eq(false)
      expect(voter.errors.messages[:zip_code]).to include("can't be blank")
    end

    it "should validate format of zip code" do
      voter = Voter.new(email: "test@test.com", zip_code: "1234")
      expect(voter.valid?).to eq(false)
      expect(voter.errors.messages[:zip_code]).to eq(["should be in the form 12345 or 12345-1234"])
    end
  end
end
