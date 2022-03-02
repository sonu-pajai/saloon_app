
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

  resources :services, only: [:index]

  resources :companies, only: [:index] do
    member do
      put "cancel" => "appointments#cancel_appointment"
    end
  end
  resources :appointments, only: [:create, :index] do
    member do
      put "cancel" => "appointments#cancel_appointment"
    end
  end
  get "monthly-report" => "reports#monthly_reports"

end
