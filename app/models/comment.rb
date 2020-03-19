class Comment < ApplicationRecord
  belongs_to :micropost
  belongs_to :user
  has_many :reaction, dependent: :destroy

  validates :body, presence: true
end
