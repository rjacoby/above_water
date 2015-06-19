# User we've whitelisted for use in the app
class WhitelistUser < ActiveRecord::Base
  def self.all_handles
    pluck(:handle)
  end

  def self.channel_handles(channel)
    self.where('channel = ?', channel).pluck(:handle)
  end

  def self.all_channels
    all.each_with_object({}) do |user, channel_hash|
      channel = channel_hash[user.channel] || []
      channel << user.handle
      channel_hash[user.channel] = channel
    end
  end

  def self.enqueue_whitelist_lookups
    all_handles.each do |handle|
      Lookup.delay.tweets_for(handle)
    end
  end
end
