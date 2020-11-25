# frozen_string_literal: true

class UsersController < ApplicationController
  include RelationshipsHelper

  before_action :logged_in_user,
                only: %i[
                  index
                  edit
                  update
                  destroy
                  following
                  followers
                ]
  before_action :correct_user, only: %i[edit update]

  def index
    @users = User.paginate(page: params[:page], per_page: 8)
  end

  def new
    @user = User.new
  end

  def show
    @user = User.find(params[:id])
    microposts_filter(@user)
    @microposts_final = @microposts_filter.paginate(page: params[:page], per_page: 8)
    @comment = Comment.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      @user.send_activation_email
      flash[:info] = 'Please check your email to activate your account.'
      redirect_to root_url
    else
      render 'new'
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      flash[:success] = 'Profile updated'
      redirect_to @user
    else
      render :edit
    end
  end

  def following
    @title = 'Following'
    @user  = User.find(params[:id])
    @users = @user.following.users_following.paginate(page: params[:page])
    render 'show_follow'
  end

  def followers
    @title = 'Followers'
    @user  = User.find(params[:id])
    @users = @user.followers.users_follower.paginate(page: params[:page])
    render 'show_follow'
  end

  private

  def microposts_filter(user)
    @microposts_filter =
      if current_user?(@user)
        user.microposts
      else
        if current_user.following?(user) && recept_request_addfriend?(user)
          user.microposts.where(micropost_statement: %w[friendly publicly])
        else
          user.microposts.where(micropost_statement: 'publicly')
                                    end
      end
  end

  def user_params
    params.require(:user).permit(
      :name,
      :email,
      :password,
      :password_confirmation
    )
  end

  # Confirms the correct user.
  def correct_user
    @user = User.find(params[:id])
    redirect_to(root_url) unless current_user?(@user)
  end
end
