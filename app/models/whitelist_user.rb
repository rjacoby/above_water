# User we've whitelisted for use in the app
class WhitelistUser < ActiveRecord::Base
  def self.all_handles
    pluck(:handle)
  end

  def self.channel_handles(channel)
    self.where('channel = ?', channel).pluck(:handle)
  end
end
