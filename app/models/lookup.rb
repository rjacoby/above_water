# Store query metainfo
class Lookup < ActiveRecord::Base
  LOOKUP_FREQUENCY_SECONDS = 15

  def self.tweets_for(twitter_id)
    lookup = find_or_create_by(query: "user/#{twitter_id}")
    if (lookup.updated_at + LOOKUP_FREQUENCY_SECONDS.seconds).past?
      Rails.logger.debug "Retrieving Tweets for @#{twitter_id}"
      lookup.touch
    else
      Rails.logger.debug "Using cached Tweets for @#{twitter_id}"
    end
    ApplicationController.twitter.user_timeline(
      twitter_id,
      count: 100,
      include_rts: false,
      exclude_replies: true
    )
  end
end
