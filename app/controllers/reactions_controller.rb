class ReactionsController < ApplicationController
  def reaction_comment
    # check xem curren_user đã react comment này chưa
    @reaction = current_user.reaction.find_by(comment_id: params[:comment_id])
    if @reaction.nil?
      # nếu chưa có, tạo mới react và lưu vào trong db
      @reaction = current_user.reaction.build
      @reaction.comment_id = params[:comment_id]
      @reaction.reactions = params[:reaction]
      if @reaction.save
        respond_to do |format|
          format.html
          format.js{ render 'reaction_comment.js.erb' }
        end
      end
    else
      # nếu đã react, check xem react cũ có trùng với react được gửi lên trong params hay k ?
      if (@reaction.reactions == params[:reaction])
        # hủy react (Kiểu click 2 lần :))
        @reaction.destroy
        respond_to do |format|
          format.html
          format.js{ render 'react_cmt_destroy.js.erb' }
        end
      else
        # update react mới
        @reaction.update_attributes(reactions: params[:reaction])
        respond_to do |format|
          format.html
          format.js{ render 'reaction_comment.js.erb' }
        end
      end
    end
  end
end
