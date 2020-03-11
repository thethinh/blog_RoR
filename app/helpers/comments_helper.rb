module CommentsHelper
  # Kiểm tra xem comment có phải của curent_user không
  def comment_of_user?(comment)
    comment.user.id == current_user.id
  end
  
  # Kiểm tra xem comment có nằm trong post của curent user không
  def comment_in_post_user?(comment)
    current_user.microposts.find_by(id: comment.micropost_id).present?
  end
  
  
end
