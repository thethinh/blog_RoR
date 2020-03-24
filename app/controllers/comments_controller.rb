class CommentsController < ApplicationController
  include CommentsHelper

  before_action :correct_cmt_user, only: [:destroy, :edit, :update] 

  def show_subcomment
    @comment_current = Comment.find_by(id: params[:comment_id])
    @subcomment = Comment.where(comment_id: params[:comment_id])
    respond_to do |format|
      format.html{render @subcomment}
      format.js
    end
  end

  def create_subcmt
    @comment_parent = Comment.find_by(id: params[:parent_id])
    @comment = @comment_parent.subcomment.build(comment_params)
    @comment.micropost_id = @comment_parent.id
    @comment.user_id = current_user.id
    if @comment.save
      respond_to do |format|
        format.html{render @subcomment}
        format.js
      end
    else
      respond_to do |format|
        format.html{render @subcomment}
        format.js
      end
    end
  end
  

  def index
    current_sum_cmt = params[:currentSumCmt].to_i
    @post = Micropost.find(params[:micropost_id])

    if(params[:currentSumCmt])
      # Nếu có số comment truyền lên thì lấy ra số  cmt = số cmt hiện tại + 4
      @comment = @post.comment.select_parent_comment.last(current_sum_cmt + 4).reverse
    else
      #Nếu chưa có params truyền lên(lúc ban đầu) thì lấy ra 7 cmt (số comment ban đầu( mặc định 3) + 4)
      @comment = @post.comment.select_parent_comment.last(7).reverse
    end
    respond_to do |format|
      format.html {redirect_to @comment}
      format.js
    end
  end

  def create
    @comment = current_user.comment.build(comment_params)
    @comment.micropost_id = params[:micropost_id]
    if @comment.save
      respond_to do |format|
        format.html{render @comment}
        format.js
      end
    else
      respond_to do |format|
        format.html{render @comment}
        format.js
      end
    end
  end

  def destroy
    @comment.destroy
    respond_to do |format|
      format.html
      format.js
    end
  end

  def edit
    respond_to  do |format|
      format.html{render @comment}
      format.js
    end
  end

  def update
    if @comment.update_attributes(comment_params)
      respond_to do |format|
        format.html{render @comment}
        format.js
      end
    else
      respond_to do |format|
        format.html{render @comment}
        format.js
      end
    end

  end
  
  private

  def comment_params
    params.require(:comment).permit(:body, :micropost_id)
  end

  def correct_cmt_user
    @comment = Comment.find_by(id: params[:id])
    
    if (@comment.nil? || (!comment_in_post_user?(@comment) && !comment_of_user?(@comment)))
      redirect_to root_url 
    end
  end
  
end
