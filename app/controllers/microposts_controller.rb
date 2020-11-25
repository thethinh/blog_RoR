# frozen_string_literal: true

class MicropostsController < ApplicationController
  before_action :logged_in_user, only: %i[create destroy]
  before_action :correct_user,   only: [:destroy]

  def create
    @micropost = current_user.microposts.build(micropost_params)
    if @micropost.save
      flash[:success] = 'Micropost created!'
      redirect_to root_url
    else
      @feed_items = []
      render 'static_pages/home'
    end
  end

  def destroy
    @micropost.destroy!
    flash[:success] = 'Micropost deleted'
    redirect_to request.referrer || root_url
  end

  def users_liked_post
    @micropost = Micropost.find_by(id: params[:micropost_id])
    uids = @micropost.reaction.pluck(:user_id)
    @users = User.where(id: uids)
    respond_to { |format| format.js { render 'users_liked_post.js.erb' } }
  end

  private

  def micropost_params
    params.require(:micropost).permit(:content, :picture, :micropost_statement)
  end

  def correct_user
    @micropost = current_user.microposts.find_by(id: params[:id])
    redirect_to root_url if @micropost.nil?
  end
end
