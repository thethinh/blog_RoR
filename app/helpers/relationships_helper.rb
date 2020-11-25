# frozen_string_literal: true

module RelationshipsHelper
  def recept_request_addfriend?(other_user)
    Relationship.find_by(followed_id: other_user.id, follower_id: current_user.id, request_status: "recepted").present?
  end

  def sum_user_request_connect
    current_user.passive_relationships.where(request_status: 'waiting_recept').order(created_at: :desc)
  end

  def get_user_from_follower_id(follower_id)
    User.find_by(id: follower_id)
  end
end
