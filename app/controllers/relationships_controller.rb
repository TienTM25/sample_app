class RelationshipsController < ApplicationController
  before_action :logged_in_user
  before_action :find_user, only: :create

  def create
    current_user.follow user
    respond_to do |format|
      format.html{redirect_to @user}
      format.js
    end
  end

  def destroy
    user = Relationship.find(params[:id]).followed
    current_user.unfollow user
    respond_to do |format|
      format.html{redirect_to @user}
      format.js
    end
  end

  private

  def find_user
    @user = User.find_by id: params[:followed_id]
    return if @user

    flash.now[:danger] = t "relationship.danger"
    redirect_to root_url
  end
end
