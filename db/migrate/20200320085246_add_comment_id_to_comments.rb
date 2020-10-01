# frozen_string_literal: true

class AddCommentIdToComments < ActiveRecord::Migration[6.0]
  def change
    add_column :comments, :comment_id, :integer
  end
end
