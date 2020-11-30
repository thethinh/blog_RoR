# frozen_string_literal: true

class StaticPagesController < ApplicationController
  def home
    if logged_in?
      @micropost  = current_user.microposts.build
      @feed_items = current_user.feed.where(user_id: current_user.id).paginate(
        page: params[:page],
        per_page: 10
      )
    end
  end

  def search_user
    if logged_in?
      @users = User.all.where("lower(name) LIKE :search OR lower(email) LIKE :search", search: "%#{params[:search].downcase}%").uniq
      respond_to { |format| format.js }
    end
  end

  def help; end

  def error_page; end
end
