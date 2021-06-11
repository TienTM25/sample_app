class UsersController < ApplicationController
  before_action :logged_in_user, only: %i(index edit update destroy)
  before_action :load_user, except: %i(create new index)
  before_action :correct_user, only: %i(edit update)
  before_action :admin_user, only: :destroy

  def index
    @users = User.page(params[:page]).per Settings.controllers.record_per_page
  end

  def show
    @microposts = @user.microposts.page(params[:page])
                       .per Settings.controllers.record_per_page
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if @user.save
      log_in @user
      @user.send_mail_activate
      flash[:success] = t "user_mailer.account_activation.check_account"
      redirect_to login_url
    else
      flash[:danger] = t "controllers.users.err_text"
      render :new
    end
  end

  def edit; end

  def update
    if @user.update user_params
      flash[:success] = t "controllers.users.update_success"
      redirect_to @user
    else
      flash[:danger] = t "controllers.users.flash_delete"
      render :edit
    end
  end

  def destroy
    if @user.destroy
      flash[:success] = t "controllers.users.flash_delete"
    else
      flash[:danger] = t "controllers.users.fail_destroy"
    end
    redirect_to users_url
  end

  private

  def load_user
    @user = User.find_by id: params[:id]
    return if @user

    flash[:danger] = t "controllers.users.user_not_found"
    redirect_to root_url
  end

  def logged_in_user
    return if logged_in?

    store_location
    flash[:danger] = t "controllers.users.err_login"
    redirect_to login_url
  end

  def admin_user
    redirect_to root_url unless current_user.admin?
  end

  def user_params
    params.require(:user).permit User::USER_ATTRS
  end

  def correct_user
    redirect_to root_url unless current_user? @user
  end
end
