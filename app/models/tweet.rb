class Tweet < ActiveRecord::Base
  belongs_to :lookup

  def hydrate
    update_attribute(:oembed_code, ApplicationController.twitter.oembed(tweet_id).html) if oembed_code.blank?
    oembed_code
  end

end
