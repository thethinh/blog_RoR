class AddPolymorphicIntoReactionToCmtAndMicropost < ActiveRecord::Migration[6.0]
  def change
    add_column :reactions, :reaction_refs_id, :integer
    add_column :reactions, :reaction_refs_type, :string

    add_index :reactions, %i[user_id reaction_refs_id], unique: true
  end
end
