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
    @comment.micropost_id = @comment_parent.micropost_id
    @comment.user_id = current_user.id
    if @comment.save
      # trả lời comment sẽ thông báo tới user có comment được reply, nếu reply comment của chính mình sẽ k có
      # reply sẽ thông báo tới cả chủ post, trừ trường hợp chủ post là người reply
      # nếu chủ comment được reply trùng với chủ post thì chỉ thông báo phản hồi bình luận
      unless reply_to_cmt_of_me?(@comment_parent)
        content_repcomment = "#{current_user.name} đã trả lời một bình luận của bạn"
        SendNotificationsService.new(content_repcomment, @comment_parent.user_id, @comment_parent.user).send_notifications
        
        if (!comment_to_post_of_me? && (@comment_parent.user_id != @comment_parent.micropost.user_id ))
          content_createcmt = "#{current_user.name} đã comment vào một post của bạn"
          SendNotificationsService.new(content_createcmt, @comment.micropost.user_id, @comment.micropost.user).send_notifications
        end
      else
        unless comment_to_post_of_me?
          content = "#{current_user.name} đã comment vào một post của bạn"
          SendNotificationsService.new(content, @comment.micropost.user_id, @comment.micropost.user).send_notifications
        end
      end
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
      # Comment vaof post của user khác thì user đó sẽ nhận đk thông báo, còn post của chính mình sẽ không
      unless comment_to_post_of_me?
        content = "#{current_user.name} đã comment vào một bài viết của bạn"
        SendNotificationsService.new(content, @comment.micropost.user_id, @comment.micropost.user).send_notifications
      end
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
    if @comment.destroy
      respond_to do |format|
        format.html
        format.js
      end
    else
      render 'static_pages/error_page'
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
    if logged_in?
      @comment = Comment.find_by(id: params[:id])
      
      if (@comment.nil? || (!comment_in_post_user?(@comment) && !comment_of_user?(@comment) && !subcmt_of_cmt_current_user?(@comment)))
        redirect_to static_pages_error_page_url 
      end
    end
  end
end
