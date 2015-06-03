# Main controller for finding and showing a user's recent Periscopes
class BroadcastersController < ApplicationController
  before_filter :set_twitter_id, only: [:list, :latest]
  before_filter :populate_user_tweets, only: [:list, :latest]

  before_filter :set_hashtag, only: [:hashtag_list, :hashtag_latest]
  before_filter :populate_hashtag_tweets, only: [:hashtag_list, :hashtag_latest]

  before_filter :identify_periscope_tweets

  def list
    @embeds = embeds(@periscope_tweets)
  end

  def latest
    unless @periscope_tweets.blank?
      redirect_to @periscope_tweets.first.urls.first.expanded_url.to_s
    end
  end

  def hashtag_list
    @embeds = embeds(@periscope_tweets)
  end

  def hashtag_latest
    unless @periscope_tweets.blank?
      redirect_to @periscope_tweets.first.urls.first.expanded_url.to_s
    end
  end

  private

  def set_twitter_id
    @twitter_id = params[:twitter_id] ? params[:twitter_id].gsub(/@/, '') : nil
  end

  def set_hashtag
    @hashtag = params[:hashtag]
  end

  def populate_user_tweets
    @tweets = ApplicationController.twitter.user_timeline(
      @twitter_id,
      count: 100,
      include_rts: false,
      exclude_replies: true
    )
  end

  def populate_hashtag_tweets
    search_str = "\##{@hashtag} periscope.tv filter:links"
    Rails.logger.debug("Search String: #{search_str}")
    @tweets = ApplicationController.twitter.search(
      search_str,
      count: 100,
      result_type: 'recent'
    )
  end

  def identify_periscope_tweets
    @periscope_tweets = tweets_with_periscopes(@tweets)
  end

  def tweets_with_periscopes(tweets)
    cutoff_time = 24.hours.ago
    tweets.select do |t|
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
