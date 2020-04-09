class ReactionsController < ApplicationController
  def reaction_comment
    # check xem curren_user đã react comment này chưa
    @reaction = current_user.reaction.find_by(comment_id: params[:comment_id])
    if @reaction.nil?
      # nếu chưa có, tạo mới react và lưu vào trong db
      @reaction = current_user.reaction.build(comment_id: params[:comment_id], reactions: params[:reaction] )
      if @reaction.save
        # Thông báo tới user được react comment
        unless react_cmt_of_me?
          content = "#{current_user.name} đã bày tỏ cảm xúc về một bình luận của bạn"
          ActionCable.server.broadcast "notifications_channel_#{@reaction.comment.user_id}",
            content: content
          NotificationsMailer.notifications_from_app(@reaction.comment.user, content).deliver_now
        end
        respond_to do |format|
          format.html
          format.js{ render 'reaction_comment.js.erb' }
        end
      else
        respond_to do |format|
          format.html
          format.js{ render 'reaction_comment.js.erb' }
        end
      end
    else
      # nếu đã react, check xem react cũ có trùng với react được gửi lên trong params hay k ?
      if (@reaction.reactions == params[:reaction])
        # hủy react (Kiểu click 2 lần :))
        if @reaction.destroy
          respond_to do |format|
            format.html
            format.js{ render 'react_cmt_destroy.js.erb' }
          end
        else
          respond_to do |format|
            format.html
            format.js{ render 'react_cmt_destroy.js.erb' }
          end
        end
      else
        # update react mới
        if @reaction.update_attributes(reactions: params[:reaction])
          respond_to do |format|
            format.html
            format.js{ render 'reaction_comment.js.erb' }
          end
        else
          respond_to do |format|
            format.html
            format.js{ render 'reaction_comment.js.erb' }
          end
        end
      end
    end
  end

  private

  def react_cmt_of_me?
    @reaction.comment.user_id == current_user.id
  end
  
end
