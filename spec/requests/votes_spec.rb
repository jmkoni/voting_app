require "rails_helper"

RSpec.describe "/votes", type: :request do
  before(:each) do
    Voter.create!(email: "hi@test.com", zip_code: "12345")
    post sessions_url, params: {voter: {email: "hi@test.com"}}
  end

  after(:each) { Voter.destroy_all }

  describe "GET /index" do
    it "renders a successful response" do
      Candidate.create! name: "Princess Peach", vote_count: 2
      Candidate.create! name: "Ash Ketchum", vote_count: 1
      get votes_url
      expect(response).to be_successful
      expect(response.body).to include("Princess Peach")
      Candidate.destroy_all
    end
  end

  describe "GET /new" do
    it "renders a successful response" do
      get new_vote_url
      expect(response).to be_successful
      expect(response.body).to include("Cast your vote today!")
    end
  end

  describe "POST /create" do
    after(:each) { Candidate.destroy_all }

    context "with valid parameters" do
      it "votes for an existing candidate" do
        candidate = Candidate.create! name: "Princess Peach", vote_count: 2
        expect {
          post votes_url, params: {vote_for: candidate.id}
        }.to change { candidate.reload.vote_count }.by(1)
      end

      it "creates a new Candidate" do
        expect {
          post votes_url, params: {candidate: {name: "Ash Ketchum"}}
        }.to change(Candidate, :count).by(1)
      end

      it "votes for existing candidate if similar candidate exists" do
        candidate = Candidate.create! name: "Ash Ketchum", vote_count: 1
        expect {
          post votes_url, params: {candidate: {name: "Ash T. Ketchum"}}
        }.to change { candidate.reload.vote_count }.by(1)
      end

      it "redirects to the created candidate" do
        post votes_url, params: {candidate: {name: "Ash Ketchum"}}
        expect(response).to redirect_to(votes_path)
      end
    end

    context "with invalid parameters" do
      it "does not create a new Candidate" do
        expect {
          post votes_url, params: {candidate: {name: ""}}
        }.to change(Candidate, :count).by(0)
      end

      it "renders a response with 422 status (i.e. to display the 'new' template)" do
        post votes_url, params: {candidate: {name: ""}}
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
end
