require "rails_helper"

RSpec.feature "Sessions" do
  after(:each) { Voter.destroy_all }

  scenario "user can log in" do
    visit new_session_path
    fill_in "Email", with: "test@test.com"
    fill_in "Zip code", with: "12345"
    click_on "Register"
    expect(page).to have_content("Cast your vote today!")
  end

  scenario "user can only vote once" do
    Voter.create! email: "test@test.com", zip_code: "12345", voted_at: Time.now
    visit new_session_path
    fill_in "Email", with: "test@test.com"
    fill_in "Zip code", with: "12345"
    click_on "Register"
    expect(page).to have_content("You have already voted!")
  end

  scenario "user can try again if they haven't voted" do
    Voter.create! email: "test@test.com", zip_code: "12345"
    visit new_session_path
    fill_in "Email", with: "test@test.com"
    fill_in "Zip code", with: "12345"
    click_on "Register"
    expect(page).to have_content("Cast your vote today!")
  end

  scenario "user must have a valid email" do
    visit new_session_path
    fill_in "Email", with: "test"
    fill_in "Zip code", with: "12345"
    click_on "Register"
    expect(page).to have_content("Email is invalid")
  end

  scenario "user must have a valid zip code" do
    visit new_session_path
    fill_in "Email", with: "test@test.com"
    fill_in "Zip code", with: "1234"
    click_on "Register"
    expect(page).to have_content("Zip code should be in the form 12345 or 12345-1234")
  end
end
