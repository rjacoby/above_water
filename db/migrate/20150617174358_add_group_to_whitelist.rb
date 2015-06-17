class AddGroupToWhitelist < ActiveRecord::Migration
  def change
    add_column :whitelist_users, :channel, :string
    add_index :whitelist_users, :channel
  end
end
