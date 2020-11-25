# frozen_string_literal: true

class RelationshipsController < ApplicationController
  def create
    @user = User.find(params[:followed_id])
    current_user.follow(@user)
    @relationship = Relationship.find_by(followed_id: @user.id, follower_id: current_user.id)
    ActionCable.server.broadcast "notifications_channel_#{@user.id}",
                                 content_relationship: @current_user.as_json(only: [:id, :name]),
                                 id_relationship: @relationship.id
    respond_to do |format|
      format.html { redirect_to @user }
      format.js
    end
  end

  def update_relationship
    @relationship = Relationship.find_by(follower_id: params[:follower_id], followed_id: current_user.id)
    @id_name = params[:id_name]

    return unless @relationship

    @result = @relationship.update(request_status: 1)
    ActionCable.server.broadcast "notifications_channel_#{params[:follower_id]}",
                                 user_relationship: current_user.as_json(only: [:id, :name])
    respond_to do |format|
      format.js
    end
  end

  def update_decline_relationship
    @relationship = Relationship.find_by(follower_id: params[:follower_id], followed_id: current_user.id)
    @id_name = params[:id_name]

    return unless @relationship

    @result = @relationship.delete

    ActionCable.server.broadcast "notifications_channel_#{params[:follower_id]}",
                                 user_decline_relationship: current_user.as_json(only: [:id, :name])
    respond_to do |format|
      format.js
    end
  end

  def destroy
    @user = Relationship.find(params[:id]).followed
    current_user.unfollow(@user)

    redirect_to @user
  end
end
