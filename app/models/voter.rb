class Voter < ApplicationRecord
  # validates both presence and format of email and zip code
  validates :email, presence: true
  validates :email, format: {with: URI::MailTo::EMAIL_REGEXP}
  validates :zip_code, presence: true
  validates_format_of :zip_code, with: /\A\d{5}-\d{4}|\A\d{5}\z/, message: "should be in the form 12345 or 12345-1234"
end
