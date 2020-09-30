# frozen_string_literal: true

class Reaction < ApplicationRecord
  belongs_to :user
  belongs_to :comment

  enum reactions: {
    Like: 0,
    Love: 1,
    Haha: 2,
    Wow: 3,
    Sad: 4,
    Angry: 5,
    Care: 6
  }
end
