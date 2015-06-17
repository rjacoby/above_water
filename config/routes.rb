Rails.application.routes.draw do
  get '/u/:twitter_id', to: 'broadcasters#latest'
  get '/user/:twitter_id', to: 'broadcasters#latest'
  get '/user/:twitter_id/latest', to: 'broadcasters#latest'
  get '/user/:twitter_id/list', to: 'broadcasters#list'

  get '/ch/:channel', to: 'broadcasters#channel_latest'
  get '/channel/:channel', to: 'broadcasters#channel_latest'
  get '/channel/:channel/latest', to: 'broadcasters#channel_latest'
  get '/channel/:channel/list', to: 'broadcasters#channel_list'

  # get '/hashtag/:hashtag', to: 'broadcasters#hashtag_list'
  # get '/hashtag/:hashtag/list', to: 'broadcasters#hashtag_list'
  # get '/hashtag/:hashtag/latest', to: 'broadcasters#hashtag_latest'

  root to: 'visitors#index'

  # Legacy from initial internal share
  get '/list/:twitter_id', to: 'broadcasters#list'
  get '/latest/:twitter_id', to: 'broadcasters#latest'

  # Rescue everything to root
  get '*path', to: redirect('/') unless Rails.env.development?
end
