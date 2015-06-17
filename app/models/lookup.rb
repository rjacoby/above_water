# Store query metainfo
class Lookup < ActiveRecord::Base
  LOOKUP_FREQUENCY_SECONDS = 15

  has_many :tweets

  def valid_tweets
    Tweet.where('tweeted_at >= ?', 24.hours.ago).order('tweeted_at DESC')
  end

  def self.tweets_for(twitter_id)
    lookup = find_or_create_by(query: "user/#{twitter_id}")
    # Check if we've never looked this up or it's past cache window
    if lookup.since_id.blank? ||
       (lookup.updated_at + LOOKUP_FREQUENCY_SECONDS.seconds).past?
      Rails.logger.debug "Fetching Tweets from API for @#{twitter_id}"
      opts_hash = {
        count: 100,
        include_rts: false,
        exclude_replies: true
      }
      opts_hash[:since_id] = lookup.since_id if lookup.since_id.present?
      tweets = ApplicationController.twitter.user_timeline(
        twitter_id,
        opts_hash
      )
      if tweets.present?
        begin
          ActiveRecord::Base.transaction do
            # Do as a bulk transaction to save a lil speed
            tweets.each do |t|
              periscope_url = nil
              t.urls.each do |u|
                current_url = u.expanded_url.to_s
                if current_url.to_s.match(/periscope/)
                  periscope_url = current_url
                  next
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
        rescue => e
          Rails.logger.error "Error writing: #{e.message}"
        end
      else
        # We didn't get new tweets b/c there aren't any.
        # Mark as recently checked.
        lookup.touch
      end
    else
      Rails.logger.debug "Using cached Tweets for @#{twitter_id}"
    end
    lookup.valid_tweets
  end
end
