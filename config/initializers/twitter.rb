ApplicationController.twitter = Twitter::REST::Client.new do |config|
  config.consumer_key = ENV['TWITTER_API_KEY']
  config.consumer_secret = ENV['TWITTER_API_SECRET']
end
