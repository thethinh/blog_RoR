class CommentsController < ApplicationController
  def index
    currentSumCmt = params[:currentSumCmt].to_i
    @post = Micropost.find(params[:micropost_id])

    if(params[:currentSumCmt])
      @comment = @post.comment.first(currentSumCmt + 4)
    else
      @comment = @post.comment.first(7)
    end
    respond_to do |format|
      format.html {redirect_to @comment}
      format.js
    end
  end
end
