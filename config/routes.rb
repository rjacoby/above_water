Rails.application.routes.draw do
  get '/user/:twitter_id', to: 'broadcasters#list'
  get '/user/:twitter_id/list', to: 'broadcasters#list'
  get '/user/:twitter_id/latest', to: 'broadcasters#latest'

  # get '/hashtag/:hashtag', to: 'broadcasters#hashtag_list'
  # get '/hashtag/:hashtag/list', to: 'broadcasters#hashtag_list'
  # get '/hashtag/:hashtag/latest', to: 'broadcasters#hashtag_latest'

  root to: 'visitors#index'

  # Legacy from initial internal share
  get '/list/:twitter_id', to: 'broadcasters#list'
  get '/latest/:twitter_id', to: 'broadcasters#latest'
end
