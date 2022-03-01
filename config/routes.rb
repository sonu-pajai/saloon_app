
Rails.application.routes.draw do
   devise_for :users,
              path_names: {
                sign_in: 'login',
                sign_out: 'logout'
              },
              controllers: {
                sessions: 'sessions',
                registrations: 'registrations'
              },
              defaults: { format: :json }

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  # Defines the root path route ("/")
  # root "users#show"
  resources :companies
  resources :services
  resources :appointments
end
