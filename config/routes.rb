# frozen_string_literal: true

Rails.application.routes.draw do
  root "home#index"

  constraints(id: /[\d\.]+(,[\d\.]+)*/) do
    concern :paginatable do
      get "(page/:page)", action: :index, on: :collection, as: ""
    end

    resources :portals, concerns: :paginatable
  end

  resources :ifs_searches
  devise_for :users, controllers: {
    session: "users/sessions",
    registrations: "users/registrations"
  }
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
