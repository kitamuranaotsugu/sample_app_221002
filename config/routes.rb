Rails.application.routes.draw do
  root to: 'homes#top'
  get '/top' => 'homes#top'
  get 'homes/about' => 'homes#about', as: 'about'
  resources :lists
end