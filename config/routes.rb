Rails.application.routes.draw do
  get 'timelines/index'
  get 'timelines/show'
  devise_for :users
  root to: 'home#index'

  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end

  authenticate :user do
    resources :timelines,
              only: [:index, :show],
              param: :username
  end

  #get 'home/index'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
