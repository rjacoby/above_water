# User we've whitelisted for use in the app
class WhitelistUser < ActiveRecord::Base
  def self.all_handles
    pluck(:handle)
  end
end
