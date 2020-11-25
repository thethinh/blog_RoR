class AddColumnStatusRelationshipIntoRelationship < ActiveRecord::Migration[6.0]
  def change
    add_column :relationships, :request_status, :integer, default: 0
  end
end
