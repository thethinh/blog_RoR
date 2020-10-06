# frozen_string_literal: true

module MicropostsHelper
  def get_all_user_like_post(micropost)
    User.where(id: micropost.reaction.pluck(:user_id))
  end
end
