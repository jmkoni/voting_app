require "rails_helper"

RSpec.feature "Votes" do
  after(:each) do
    Candidate.destroy_all
    Voter.destroy_all
  end

  scenario "user can see results" do
    Candidate.create! name: "Princess Peach", vote_count: 2
    Candidate.create! name: "Ash Ketchum", vote_count: 1
    visit votes_path
    expect(page).to have_content("Princess Peach")
    expect(page).to have_content("Ash Ketchum")
  end

  scenario "user can vote for an existing candidate" do
    candidate = Candidate.create! name: "Princess Peach", vote_count: 2
    visit new_session_path
    fill_in "Email", with: "test@test.com"
    fill_in "Zip code", with: "12345"
    click_on "Register"
    expect(page).to have_content("Cast your vote today!")
    choose "vote_for_#{candidate.id}"
    click_on "vote_for_existing_candidate"
    expect(candidate.reload.vote_count).to eq(3)
    expect(page).to have_content("Vote was successfully cast!")
  end

  scenario "user can vote for an existing candidate by matching the name" do
    candidate = Candidate.create! name: "Princess Peach", vote_count: 2
    visit new_session_path
    fill_in "Email", with: "test@test.com"
    fill_in "Zip code", with: "12345"
    click_on "Register"
    expect(page).to have_content("Cast your vote today!")
    fill_in "candidate_name", with: "Princess P. Peach"
    click_on "vote_for_new_candidate"
    expect(candidate.reload.vote_count).to eq(3)
    expect(page).to have_content("Vote was successfully cast!")
  end

  scenario "user can vote for an new candidate" do
    candidate = Candidate.create! name: "Princess Peach", vote_count: 2
    visit new_session_path
    fill_in "Email", with: "test@test.com"
    fill_in "Zip code", with: "12345"
    click_on "Register"
    expect(page).to have_content("Cast your vote today!")
    fill_in "candidate_name", with: "Bowser"
    click_on "vote_for_new_candidate"
    expect(candidate.reload.vote_count).to eq(2)
    new_candidate = Candidate.last
    expect(new_candidate.name).to eq("Bowser")
    expect(new_candidate.vote_count).to eq(1)
    expect(page).to have_content("Vote was successfully cast!")
  end
end
