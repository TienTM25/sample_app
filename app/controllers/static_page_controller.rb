class StaticPageController < ApplicationController
  def home
    return unless logged_in?

    # return micropost object
    @micropost = current_user.microposts.build
    @feed_items = current_user.feed.order_post.page(params[:page])
                              .per Settings.controllers.record_per_page
  end

  def help; end

  def about; end

  def contact; end
end
