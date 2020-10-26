# frozen_string_literal: true

class StaticPagesController < ApplicationController
  def home
    if logged_in?
      @micropost  = current_user.microposts.build
      @feed_items = current_user.feed.where(user_id: current_user.following.pluck(:id)).paginate(
        page: params[:page],
        per_page: 10
      )
    end
  end

  def help
    # code here
  end

  def error_page; end
end
