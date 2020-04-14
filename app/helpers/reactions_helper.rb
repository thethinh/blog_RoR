module ReactionsHelper
  def get_reaction_current_user(comment)
    current_user.reaction.find_by(comment_id: comment.id)
  end

  def react_cmt_of_me?
    @reaction.comment.user_id == current_user.id
  end
  
end
