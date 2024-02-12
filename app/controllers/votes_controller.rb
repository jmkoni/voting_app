class VotesController < ApplicationController
  # GET /votes
  # Lists all candidates and vote counts
  def index
    @candidates = Candidate.all
  end

  # GET /votes/new
  # because the timer redirects if there's not a current user,
  # this can only be accessed by a voter who hasn't exceeded the time limit
  def new
    @candidate = Candidate.new
  end

  # POST/PATCH /votes
  # If the voter is voting for an existing candidate, increments the vote count
  # If the voter is voting for a new candidate, checks for similarities against existing candidates
  # or creates a new candidate if none is found (see models/candidate.rb)
  def create
    if params[:vote_for]
      @candidate = Candidate.find(params[:vote_for])
      @candidate.vote_count += 1
      @candidate.save
    else
      @candidate = Candidate.add_new_candidate(params[:candidate][:name])
    end

    if @candidate.errors.any?
      render :new, status: :unprocessable_entity
    else
      current_user.update(voted_at: Time.now)
      logout_voter
      redirect_to votes_path, notice: "Vote was successfully cast!"
    end
  end
end
