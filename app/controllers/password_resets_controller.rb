class PasswordResetsController < ApplicationController
  before_action :get_user, :valid_user, :check_exp, only: %i(edit update)
  def new; end

  def create
    @user = User.find_by email: params[:password_reset][:email].downcase
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      redirect_to root_url
    else
      render :new
    end
  end

  def edit; end

  def update
    if params[:user][:password].blank?
      @user.errors.add :password
      render :edit
    elsif @user.update user_params
      check_update @user
    else
      flash.now[:danger] = t "controllers.password_resets.update_fail"
      render :edit
    end
  end

  private
  def check_update user
    log_in user
    user.update_attribute :reset_digest, nil
    flash[:success] = t "controllers.password_resets.update_success"
    redirect_to user
  end

  def user_params
    params.require(:user).permit User::USER_PERMIT
  end

  def get_user
    @user = User.find_by email: params[:email]
    return if @user

    flash[:danger] = t "controllers.users.user_not_found"
    redirect_to root_url
  end

  def valid_user
    return if @user.activated? && @user.authenticated?(:reset, params[:id])

    redirect_to root_url
  end

  def check_exp
    return unless @user.password_reset_expired?

    flash[:danger] = t "controllers.password_resets.password_expire"
    redirect_to new_password_reset_url
  end
end
