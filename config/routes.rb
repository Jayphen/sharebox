Sharebox::Application.routes.draw do
  
  resources :assets

  devise_for :users

  root :to => "home#index"
  
  #this route is for file downloads
  match "assets/get/:id" => "assets#get", :as => "download"
end