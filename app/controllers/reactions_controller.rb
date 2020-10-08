# frozen_string_literal: true

class ReactionsController < ApplicationController
  include ReactionsHelper

  def reaction_comment
    # check xem curren_user đã react comment này chưa
    @reaction = current_user.reaction.find_by(reaction_refs_id: params[:reaction_refs_id], reaction_refs_type: 'Comment')
    if @reaction.nil?
      # nếu chưa có, tạo mới react và lưu vào trong db
      @reaction = current_user.reaction.build(reaction_refs_id: params[:reaction_refs_id], reactions: params[:reaction], reaction_refs_type: 'Comment')
      if @reaction.save
        # Thông báo tới user được react comment
        unless react_of_me?(@reaction)
          content = "#{current_user.name} đã bày tỏ cảm xúc về một bình luận của bạn"
          SendNotificationsService.new(content, @reaction.reaction_refs.user_id, @reaction.reaction_refs.user).send_notifications
        end
        respond_to do |format|
          format.html
          format.js { render 'reaction_comment.js.erb' }
        end
      else
        render 'static_pages/error_page'
      end
    else
      # nếu đã react, check xem react cũ có trùng với react được gửi lên trong params hay k ?
      if @reaction.reactions == params[:reaction]
        # hủy react (Kiểu click 2 lần :))
        if @reaction.destroy
          respond_to do |format|
            format.html
            format.js { render 'react_cmt_destroy.js.erb' }
          end
        else
          render 'static_pages/error_page'
        end
      else
        # update react mới
        if @reaction.update(reactions: params[:reaction])
          respond_to do |format|
            format.html
            format.js { render 'reaction_comment.js.erb' }
          end
        else
          render 'static_pages/error_page'
        end
      end
    end
  end

  def reaction_micropost
    @reaction_post = current_user.reaction.find_by(reaction_refs_id: params[:reaction_refs_id], reaction_refs_type: 'Micropost')

    if @reaction_post.nil?
      @reaction_post = current_user.reaction.build(reaction_refs_id: params[:reaction_refs_id], reactions: params[:reaction], reaction_refs_type: 'Micropost')
      if @reaction_post.save
        unless react_of_me?(@reaction_post)
          content = "#{current_user.name} đã thích một bài viết của bạn"
          SendNotificationsService.new(content, @reaction_post.reaction_refs.user_id, @reaction_post.reaction_refs.user).send_notifications
        end
      end
      respond_to do |format|
        format.html
        format.js { render 'reaction_micropost.js.erb' }
      end
    else
      @reaction_post.destroy!
      respond_to do |format|
        format.html
        format.js { render 'reaction_micropost_destroy.js.erb' }
      end
    end
  end
end
