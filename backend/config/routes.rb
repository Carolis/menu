Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :restaurants do
        resources :menus, except: [ :index ]
        resources :reviews
      end
      resources :menus do
        resources :menu_items, except: [ :index ]
      end
      resources :menu_items

      post "import/restaurants", to: "imports#create"
      post "auth/verify", to: "sessions#verify"
    end
  end
end
