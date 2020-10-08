# frozen_string_literal: true

module ReactionsHelper
  def get_reaction_current_user(type)
    current_user.reaction.find_by(reaction_refs_id: type.id, reaction_refs_type: (type.class == Comment ? 'Comment' : 'Micropost'))
  end

  def react_of_me?(type_reaction)
    type_reaction.reaction_refs.user_id == current_user.id
  end
end
