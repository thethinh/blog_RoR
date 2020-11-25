class AddColumnStatePostToMicropost < ActiveRecord::Migration[6.0]
  def change
    add_column :microposts, :micropost_statement, :integer, :default => 2
  end
end
