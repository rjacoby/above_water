require File.expand_path('../../config/boot',        __FILE__)
require File.expand_path('../../config/environment', __FILE__)
require 'clockwork'

include Clockwork

every(1.minute, 'Queueing tweet retrieval for whitelist') { WhitelistUser.enqueue_whitelist_lookups }
