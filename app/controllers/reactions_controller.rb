# frozen_string_literal: true

class ReactionsController < ApplicationController
  include ReactionsHelper

  def reaction_comment
    # check xem curren_user đã react comment này chưa
    @reaction = current_user.reaction.find_by(reaction_refs_id: params[:reaction_refs_id])
    if @reaction.nil?
      # nếu chưa có, tạo mới react và lưu vào trong db
      @reaction = current_user.reaction.build(reaction_refs_id: params[:reaction_refs_id], reactions: params[:reaction], reaction_refs_type: 'Comment')
      if @reaction.save
        # Thông báo tới user được react comment
        unless react_cmt_of_me?
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
        if @reaction.update_attributes(reactions: params[:reaction])
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
end
