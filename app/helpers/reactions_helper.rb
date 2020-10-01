# frozen_string_literal: true

module ReactionsHelper
  def get_reaction_current_user(comment)
    current_user.reaction.find_by(reaction_refs_id: comment.id)
  end

  def react_cmt_of_me?
    @reaction.reaction_refs.user_id == current_user.id
  end
end
