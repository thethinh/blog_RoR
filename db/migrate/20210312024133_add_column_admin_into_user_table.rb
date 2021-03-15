class AddColumnAdminIntoUserTable < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :is_admin, :boolean, :default => false
  end
end
