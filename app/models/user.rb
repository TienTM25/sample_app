class User < ApplicationRecord
  USER_ATTRS = %i(name email password password_confirmation).freeze

  before_save :downcase_email
  validates :name, presence: true, length: {maximum: Settings.user.name}
  validates :email, presence: true, length: {maximum: Settings.user.email},
                    format: {with: Settings.user.regex_email},
                    uniqueness: true
  has_secure_password
  validates :password, presence: true, length: {minimum: Settings.user.password}

  private

  def downcase_email
    email.downcase!
  end
end
