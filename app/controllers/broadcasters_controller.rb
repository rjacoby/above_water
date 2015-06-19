# Main controller for finding and showing a user's recent Periscopes
class BroadcastersController < ApplicationController
  @@whitelist = WhitelistUser.all_handles
  @@whitelist_updated_at = Time.now
  @@channels = nil
  @@channels_updated_at = 1.day.ago

  before_filter :set_twitter_id, only: [:list, :latest]
  before_filter :check_whitelist, only: [:list, :latest]

  before_filter :set_channel, only: [:channel_list, :channel_latest]
  before_filter :build_channels, only: [:channel_list, :channel_latest]

  before_filter :populate_user_tweets, only: [:list, :latest]
  before_filter :populate_channel_tweets, only: [:channel_list, :channel_latest]

  before_filter :set_hashtag, only: [:hashtag_list, :hashtag_latest]
  before_filter :populate_hashtag_tweets, only: [:hashtag_list, :hashtag_latest]

  before_filter :redirect_to_latest, only: [:latest, :channel_latest, :hashtag_latest]
  before_filter :populate_embeds, only: [:list, :hashtag_list, :channel_list]

  def list
  end

  def latest
  end

  def channel_list
  end

  def channel_latest
  end

  def hashtag_list
  end

  def hashtag_latest
  end

  private

  def set_twitter_id
    @twitter_id = params[:twitter_id] ? params[:twitter_id].gsub(/@/, '').downcase : nil
  end

  def set_channel
    @channel = params[:channel] ? params[:channel].downcase : nil
  end

  def check_whitelist
    now = Time.now
    if (@@whitelist_updated_at + 1.minute) < now
      # Refresh from DB every minute
      Rails.logger.debug('Updating whitelist from DB')
      @@whitelist = WhitelistUser.all_handles
      @@whitelist_updated_at = now
    end
    redirect_to '/' unless @@whitelist.include?(@twitter_id)
  end

  def build_channels
    now = Time.now
    if (@@channels_updated_at + 1.minute) < now
      @@channels = WhitelistUser.all.each_with_object({}) do |user, channel_hash|
        channel = channel_hash[user.channel] || []
        channel << user.handle
        channel_hash[user.channel] = channel
      end
      @@channels_updated_at = now
    end
    redirect_to '/' unless @@channels.keys.include?(@channel)
  end

  def set_hashtag
    @hashtag = params[:hashtag] ? params[:hashtag].gsub(/#/, '') : nil
  end

  def populate_user_tweets
    if (lookup = Lookup.find_by_twitter_id(@twitter_id))
      @periscope_tweets = lookup.valid_tweets
    end
  end

  def populate_channel_tweets
    @periscope_tweets = Lookup.channel_tweets(@channel)
  end

  # FIXME: Move to model and filter for periscope - doesn't work now, but is disabled
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

  def redirect_to_latest
    redirect_to @periscope_tweets.first.periscope_url, status: 307 unless @periscope_tweets.blank?
  end
end
