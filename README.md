Above Water
================

[![Deploy to Heroku](https://www.herokucdn.com/deploy/button.png)](https://heroku.com/deploy)

This is a simple app that provides an easy way to find [Periscope](http://periscope.tv) broadcasts Twitter user.

There are two main functions:
- List all of the user's Tweeted broadcasts in the last 24 hours
- Go directly to the most recent Tweeted broadcasts

Shortcut URLs
-------------
Both functions are available as RESTful shortcut URLs:
- /list/<twitterhandle>
- /latest/<twitterhandle>

The 'latest' shortcut could be useful for a kiosk view or evergreen URL.

What It Does
------------
I know you'll read the code anyway, but here's the basics.

- Get @handle's 100 most recent Tweets
- Isolate the Tweets within the last 24hrs that have Periscope URLs in them
- Either redirect to most recent broadcast
- Or retrieve [Twitter OEmbed code](https://dev.twitter.com/rest/reference/get/statuses/oembed) to show a list of the Tweets


Ruby on Rails
-------------

This application requires:

- Ruby 2.2.0
- Rails 4.2.0

Learn more about [Installing Rails](http://railsapps.github.io/installing-rails.html).

Getting Started
---------------
You must create a [Twitter app](https://apps.twitter.com). It only needs 'read' permissions, and works with the app's token - not a user-level one, so no logins are required.

Set the credentials in your .env file or on Heroku as:
- TWITTER_API_KEY
- TWITTER_API_SECRET

Issues
-------------
- No tests
- No caching
- Hits rate limits
- Minimal error checking
- Very basic look&feel
- Not super smart about multiple URLs in a broadcast Tweet
- Limited by Periscope behavior
  - Cannot IFrame in a broadcast
  - Cannot currently view completed brodcasts on web - but works nicely on mobile!
