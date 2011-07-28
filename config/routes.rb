Tomotomo::Application.routes.draw do
  match '/auth/:provider/callback' => 'sessions#callback'
  match "/signout" => "sessions#destroy", :as => :signout

  match '/mail/about' => 'mail#about'
  match '/mail/sent' => 'mail#sent'
  match '/mail/pool' => 'mail#pool'
  get '/mail/show_sent/:id' => 'mail#show_sent'
  get '/mail/new'
  get '/mail/reply/:id' => 'mail#reply'
  post '/mail/create'
  post '/mail/create_reply'

  root :to => "mail#index"
end
