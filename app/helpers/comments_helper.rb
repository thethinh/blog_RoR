module CommentsHelper
  # Kiểm tra xem comment có phải của curent_user không
  def comment_of_user?(comment)
    comment.user.id == current_user.id
  end
  
  # Kiểm tra xem comment có nằm trong post của curent user không
  def comment_in_post_user?(comment)
    current_user.microposts.find_by(id: comment.micropost_id).present?
  end
  
  # Kiểm tra xem comment reply có thuộc comment cha của curent user khong
  def subcmt_of_cmt_current_user?(comment)
    current_user.comment.find_by(id: comment.comment_id).present?
  end

  # check tra xem có comment vào post của chính mình hay không ?
  def comment_to_post_of_me?
    @comment.micropost.user_id == current_user.id
  end

  # check tra xem có reply comment của chính mình hay không ?
  def reply_to_cmt_of_me?(comment)
    comment.user_id == current_user.id
  end

end
