# Main controller for finding and showing a user's recent Periscopes
class BroadcastersController < ApplicationController
  def show
    @twitter_id = params[:twitter_id]
    @tweets = ApplicationController.twitter.user_timeline(
      @twitter_id,
      count: 200,
      include_rts: false,
      exclude_replies: true
    )
    @embeds = embeds(tweets_with_periscopes(@tweets))
  end

  private

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
