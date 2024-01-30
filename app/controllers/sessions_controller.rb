class SessionsController < ApplicationController
  # GET /sessions/new
  # Logs out user any time they visit the login page
  def new
    logout_voter if current_user
    @voter = Voter.new
  end

  # POST/PATCH /sessions
  # Checks if voter exists and has not voted yet
  # If so, logs them in and redirects them to the voting page
  # If not, redirects them to the voting page with a message
  # If voter does not exist, creates a new voter and logs them in
  def create
    @voter = Voter.find_by(email: voter_params[:email])
    if @voter && !@voter.voted_at
      login_voter
    elsif @voter
      logout_voter
      redirect_to votes_path, notice: "You have already voted!"
    else
      @voter = Voter.new(voter_params)
      if @voter.save
        login_voter
      else
        render :new, status: :unprocessable_entity
      end
    end
  end

  # DELETE /sessions/1
  # logs out voter
  def destroy
    logout_voter
    redirect_to votes_path
  end

  private

  # Logs in voter by setting the encrypted voter_id cookie and setting the signed_in_at time
  def login_voter
    # signed_in_at ended up not really being used
    @voter.update(signed_in_at: Time.now)
    cookies.encrypted[:voter_id] = @voter.id
    cookies[:start_time] = Time.now.strftime("%d %b %Y %H:%M:%S %Z")
    redirect_to new_vote_path
  end

  # Only allow a list of trusted parameters through.
  def voter_params
    params.require(:voter).permit(:email, :zip_code)
  end
end
