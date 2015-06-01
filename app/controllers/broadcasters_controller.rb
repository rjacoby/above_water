# Main controller for finding and showing a user's recent Periscopes
class BroadcastersController < ApplicationController
  def show
    @twitter_id = params[:twitter_id]
    @tweets = ApplicationController.twitter.user_timeline(@twitter_id)
    @embeds = embeds(@tweets)
  end

  private

  def embeds(tweets)
    tweets.each_with_object({}) do |t, h|
      h[t.id] = ApplicationController.twitter.oembed(t.id)
    end
  end
end
