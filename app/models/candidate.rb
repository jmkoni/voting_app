require "text"

class Candidate < ApplicationRecord
  validate :not_more_than_ten
  validates :name, presence: true

  # This is a custom validation that checks if there are already 10 candidates
  def not_more_than_ten
    if Candidate.count == 10
      errors.add(:candidate, "can only have 10 total candidates")
    end
  end

  # This checks for similar candidates and returns the closest match
  # If there is no close match, it creates a new candidate
  def self.add_new_candidate(candidate_name)
    closest = closest_match(candidate_name)
    if closest.present?
      closest.vote_count += 1
      closest.save
      return closest
    end
    Candidate.create(name: candidate_name, vote_count: 1)
  end

  # This uses the Levenshtein distance algorithm to check for similar candidates
  # There are likely better ways to do this, but this was the simplest option in the time limit.
  # https://en.wikipedia.org/wiki/Levenshtein_distance
  def self.closest_match(candidate_name)
    return nil if candidate_name.blank?
    Candidate.all.each do |candidate|
      # Did a bit of testing and 7 seems to be a good threshold for a match
      if Text::Levenshtein.distance(candidate_name, candidate.name) < 5
        return candidate
      end
    end
    nil
  end
end
