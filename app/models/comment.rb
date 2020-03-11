class Comment < ApplicationRecord
  belongs_to :micropost
  belongs_to :user

  validates :body, presence: true
end
