# Store the users we'll respond for
class CreateWhitelistUsers < ActiveRecord::Migration
  def change
    create_table :whitelist_users do |t|
      t.string :handle

      t.timestamps null: false
    end
    add_index :whitelist_users, :handle, unique: true
  end
end
