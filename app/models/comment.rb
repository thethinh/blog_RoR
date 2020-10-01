# frozen_string_literal: true

class Comment < ApplicationRecord
  belongs_to :micropost
  belongs_to :user
  has_many :reaction, as: :reaction_refs, dependent: :destroy
  has_many :subcomment, class_name: 'Comment', foreign_key: 'comment_id', dependent: :destroy

  validates :body, presence: true

  scope :select_parent_comment, -> { where(comment_id: nil) }
end
