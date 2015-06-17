class AddGroupToWhitelist < ActiveRecord::Migration
  def change
    add_column :whitelist_users, :group, :string
    add_index :whitelist_users, :group
  end
end
