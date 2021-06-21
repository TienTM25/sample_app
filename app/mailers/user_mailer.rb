class UserMailer < ApplicationMailer
  def account_activation user
    @user = user

    mail to: user.email, subject: t("user_mailer.subject")
  end

  def password_reset user
    @user = user
    mail to: user.email, subject: t("user_mailer.account_reset_text")
  end
end
