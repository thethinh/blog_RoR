module ReactionsHelper
  def react_current_user(comment)
    current_user.reaction.find_by(comment_id: comment.id)
  end
  
end
