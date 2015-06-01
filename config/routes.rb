Rails.application.routes.draw do
  get '/list/:twitter_id', to: 'broadcasters#list'
  get '/latest/:twitter_id', to: 'broadcasters#latest'

  root to: 'visitors#index'
end
