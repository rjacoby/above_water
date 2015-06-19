# Store query metainfo
class Lookup < ActiveRecord::Base
  has_many :tweets

  def self.find_by_twitter_id(twitter_id)
    where('query = ?', "user/#{twitter_id}").first
  end

  def self.find_by_twitter_id_array(twitter_id_array)
    where(query: twitter_id_array.each_with_object([]) { |t, arr| arr << "user/#{t}" })
  end

  def valid_tweets
    Tweet.where('lookup_id = ?', id)
      .where('tweeted_at >= ?', 24.hours.ago)
      .order('tweeted_at DESC')
  end

  def self.tweets_for(twitter_id)
    lookup = find_or_create_by(query: "user/#{twitter_id}")
    Rails.logger.debug "Fetching Tweets from API for @#{twitter_id}"
    opts_hash = {
      count: 50,
      include_rts: false,
      exclude_replies: true
    }
    opts_hash[:since_id] = lookup.since_id if lookup.since_id.present?
    begin
      tweets = ApplicationController.twitter.user_timeline(
        twitter_id,
        opts_hash
      )
    rescue Twitter::Error => e
      # Ignore missing handles and such
      Rails.logger.error(e.message)
    end
    if tweets.present?
      begin
        ActiveRecord::Base.transaction do
          # Do as a bulk transaction to save a lil speed
          tweets.each do |t|
            next if t.created_at <= 24.hours.ago
            periscope_url = nil
            if t.source.match(/periscope\.tv/)
              t.urls.each do |u|
                current_url = u.expanded_url.to_s
                if current_url.to_s.match(/periscope\.tv/)
                  periscope_url = current_url
                  next
                end
              end
            end
            if periscope_url
              Tweet.create(
                lookup: lookup,
                tweet_id: t.id,
                tweeted_at: t.created_at,
                periscope_url: periscope_url
              )
            end
          end
          lookup.update_attribute(:since_id, tweets.first.id)
        end
      # rescue => e
      #   Rails.logger.error "Error writing: #{e.message}"
      end
    else
      # We didn't get new tweets b/c there aren't any.
      # Mark as recently checked.
      lookup.touch
    end
    lookup.valid_tweets
  end

  def self.channel_tweets(channel)
    lookups = find_by_twitter_id_array(WhitelistUser.channel_handles(channel))
    all_tweets = lookups.each_with_object([]) do |l, tweets|
      tweets << l.valid_tweets
    end
    all_tweets.flatten!.sort! { |a, b| b.tweeted_at <=> a.tweeted_at } unless all_tweets.blank?
    all_tweets
  end
end
