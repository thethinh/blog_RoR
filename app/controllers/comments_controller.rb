class CommentsController < ApplicationController
  def index
    current_Sum_Cmt = params[:currentSumCmt].to_i
    @post = Micropost.find(params[:micropost_id])

    if(params[:currentSumCmt])
      # Nếu có số comment truyền lên thì lấy ra số  cmt = số cmt hiện tại + 4
      @comment = @post.comment.first(current_Sum_Cmt + 4)
    else
      #Nếu chưa có params truyền lên(lúc ban đầu) thì lấy ra 7 cmt (số comment ban đầu( mặc định 3) + 4)
      @comment = @post.comment.first(7)
    end
    respond_to do |format|
      format.html {redirect_to @comment}
      format.js
    end
  end
end
