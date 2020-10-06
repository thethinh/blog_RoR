# frozen_string_literal: true

class RemoveForeignKeyCommentIdInReaction < ActiveRecord::Migration[6.0]
  def change
    remove_reference :reactions, :comment, index: true, foreign_key: true
  end
end
