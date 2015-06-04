class CreateTweets < ActiveRecord::Migration
  def change
    create_table :tweets do |t|
      t.references :lookup
      t.string :tweet_id
      t.timestamp :tweeted_at
      t.string :periscope_url
      t.text :oembed_code

      t.timestamps null: false
    end
    add_foreign_key :tweets, :lookups
    add_index :tweets, :tweet_id, unique: true
  end
end
