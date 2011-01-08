RedditBFBC2::Application.routes.draw do
  resources :players, :only => [:index, :show, :new, :create] do
    get 'update', :to => {:action => 'update'}
  end
  
  root :to => "players#index"
end
