Rails.application.routes.draw do
  get '/p/:twitter_id', to: 'broadcasters#show'
  root to: 'visitors#index'
end
