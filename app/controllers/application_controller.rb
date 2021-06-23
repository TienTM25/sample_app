class ApplicationController < ActionController::Base
  before_action :set_locale
  include SessionsHelper

  private

  def find_user
    @user = User.find_by id: params[:id]
    return if @user

    flash[:danger] = t "controllers.users.user_not_found"
    redirect_to @user
  end

  def logged_in_user
    return if logged_in?

    store_location
    flash[:danger] = t "controllers.users.err_login"
    redirect_to login_url
  end

  def set_locale
    locale = params[:locale].to_s.strip.to_sym || I18n.default.locale
    lang = I18n.available_locales.include?(locale)
    I18n.locale = lang ? locale : I18n.default_locale
  end

  def default_url_options
    {locale: I18n.locale}
  end
end
