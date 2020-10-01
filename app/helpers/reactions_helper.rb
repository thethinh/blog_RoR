# frozen_string_literal: true

module ReactionsHelper
  def get_reaction_current_user(comment)
    current_user.reaction.find_by(reaction_refs_id: comment.id, reaction_refs_type: 'Comment')
  end

  def react_of_me?
    @reaction_post.reaction_refs.user_id == current_user.id
  end

  def get_reaction_current_user(micropost)
    current_user.reaction.find_by(reaction_refs_id: micropost.id, reaction_refs_type: 'Micropost')
  end
end
