class CommentsController < ApplicationController
  def index
    @post = Micropost.find(params[:micropost_id])
    @comment = @post.comment
    respond_to do |format|
      format.html {redirect_to @comment}
      format.js
    end
  end
end
