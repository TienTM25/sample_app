class User < ApplicationRecord
  before_save :downcase_email

  validates :name, presence: true, length: {maximum: Settings.user.name}
  VALID_EMAIL_REGEX = Settings.user.regex_email
  validates :email, presence: true, length: {maximum: Settings.user.email},
                    format: {with: VALID_EMAIL_REGEX},
                    uniqueness: true
  has_secure_password
  validates :password, presence: true,
                       length: {minimum: Settings.user.password}

  private

  def downcase_email
    email.downcase!
  end
end
