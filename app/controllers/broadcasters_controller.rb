# Main controller for finding and showing a user's recent Periscopes
class BroadcastersController < ApplicationController
  before_filter :set_twitter_id, only: [:list, :latest]
  before_filter :populate_user_tweets, only: [:list, :latest]

  before_filter :set_hashtag, only: [:hashtag_list, :hashtag_latest]
  before_filter :populate_hashtag_tweets, only: [:hashtag_list, :hashtag_latest]

  before_filter :populate_embeds, only: [:list, :hashtag_list]

  def list
  end

  def latest
    unless @periscope_tweets.blank?
      redirect_to @periscope_tweets.first.periscope_url,
                  status: 307
    end
  end

  def hashtag_list
  end

  def hashtag_latest
    unless @periscope_tweets.blank?
      redirect_to @periscope_tweets.first.urls.first.expanded_url.to_s,
                  status: 307
    end
  end

  private

  def set_twitter_id
    @twitter_id = params[:twitter_id] ? params[:twitter_id].gsub(/@/, '') : nil
  end

  def set_hashtag
    @hashtag = params[:hashtag] ? params[:hashtag].gsub(/#/, '') : nil
  end

  def populate_user_tweets
    @periscope_tweets = Lookup.tweets_for(params[:twitter_id])
  end

  # TODO: Move to model and filter for periscope
  def populate_hashtag_tweets
    search_str = "\##{@hashtag} periscope.tv filter:links"
    Rails.logger.debug("Search String: #{search_str}")
    @tweets = ApplicationController.twitter.search(
      search_str,
      count: 100,
      result_type: 'recent'
    )
  end

  def populate_embeds
    @embeds = @periscope_tweets.each_with_object({}) do |t, h|
      h[t.tweet_id] = t.hydrate
    end
  end
end
