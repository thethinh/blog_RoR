class Comment < ApplicationRecord
  belongs_to :micropost
  belongs_to :user
  has_many :reaction, dependent: :destroy
  has_many :subcomment, class_name: "Comment", foreign_key: "comment_id", dependent: :destroy

  validates :body, presence: true

  scope :discriminate_cmt_and_subcmt, -> { where(comment_id: nil) }
  # Ex:- scope :active, -> {where(:active => true)}
end
