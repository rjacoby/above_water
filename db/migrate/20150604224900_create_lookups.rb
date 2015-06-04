class CreateLookups < ActiveRecord::Migration
  def change
    create_table :lookups do |t|
      t.string :query
      t.string :since_id

      t.timestamps null: false
    end
    add_index :lookups, :query, unique: true
  end
end
