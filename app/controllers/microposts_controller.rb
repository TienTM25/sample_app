class MicropostsController < ApplicationController
  before_action :logged_in_user, only: %i(create destroy)
  before_action :correct_user, only: :destroy

  def create
    @micropost = current_user.microposts.build micropost_params
    @micropost.image.attach params[:micropost][:image]
    if @micropost.save
      flash[:success] = t "microposts.save_success"
      redirect_to root_url
    else
      save_fail
    end
  end

  def destroy
    if @micropost.destroy
      flash[:success] = t "microposts.destroy_success"
    else
      flash[:danger] = t "microposts.destroy_fall"
    end
    redirect_to request.referer || root_url
  end

  private

  def micropost_params
    params.require(:micropost).permit Micropost::MICRO_PARAMS
  end

  def correct_user
    @micropost = current_user.microposts.find_by id: params[:id]
    redirect_to root_url unless @micropost
  end

  def save_fail
    flash[:danger] = t "microposts.save_fail"
    record = Settings.controllers.record_per_page
    @feed_items = current_user.feed.page(params[:page]).per record
    render "static_page/home"
  end
end
