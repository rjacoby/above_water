# Main controller for finding and showing a user's recent Periscopes
class BroadcastersController < ApplicationController
  before_filter :set_twitter_id
  before_filter :populate_tweets
  before_filter :identify_periscope_tweets

  def list
    @embeds = embeds(@periscope_tweets)
  end

  def latest
    unless @periscope_tweets.blank?
      redirect_to @periscope_tweets.first.urls.first.expanded_url.to_s
    end
  end

  private

  def set_twitter_id
    @twitter_id = params[:twitter_id].gsub(/@/, '')
  end

  def populate_tweets
    @tweets = ApplicationController.twitter.user_timeline(
      @twitter_id,
      count: 100,
      include_rts: false,
      exclude_replies: true
    )
  end

  def identify_periscope_tweets
    @periscope_tweets = tweets_with_periscopes(@tweets)
  end

  def tweets_with_periscopes(tweets)
    cutoff_time = 24.hours.ago
    tweets.select! do |t|
      has_periscope = false
      next if t.created_at < cutoff_time
      t.urls.each do |u|
        if u.expanded_url.to_s.match(/periscope/)
          has_periscope = true
          next
        end
      end
      has_periscope
    end
  end

  def embeds(tweets)
    tweets.each_with_object({}) do |t, h|
      h[t.id] = ApplicationController.twitter.oembed(t.id)
    end
  end
end
