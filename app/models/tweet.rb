# Basic Tweet object
class Tweet < ActiveRecord::Base
  belongs_to :lookup

  def hydrate
    update_attribute(:oembed_code, ApplicationController.twitter.oembed(tweet_id).html) if oembed_code.blank?
    return oembed_code
  rescue Twitter::Error => e
    Rails.logger.error(e.message)
    return nil
  end
end
