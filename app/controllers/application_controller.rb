class ApplicationController < ActionController::Base
  helper_method :current_user

  private

  # Logs out voter by deleting the encrypted voter_id cookie and setting the current_user to nil
  def logout_voter
    @current_user = nil
    cookies.encrypted[:voter_id] = nil
    cookies[:start_time] = nil
  end

  # Returns the current logged-in user
  def current_user
    @current_user ||= if cookies.encrypted[:voter_id]
      voter = Voter.find_by(id: cookies.encrypted[:voter_id])
      if voter
        voter
      else
        cookies.encrypted[:voter_id] = nil
        cookies[:start_time] = nil
        nil
      end
    end
  end
end
