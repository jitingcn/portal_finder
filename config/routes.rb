# frozen_string_literal: true

Rails.application.routes.draw do
  root "home#index"

  constraints(id: /[\d\.]+(,[\d\.]+)*/) do
    resources :portals
  end

  get "portals/search", action: :search, controller: "portals"

  get "portals/(page/:page)", action: :index, controller: "portals"

  resources :ifs_searches
  get "ifs/:uuid", action: :uuid, controller: "ifs_searches"

  devise_for :users, controllers: {
      session: "users/sessions",
      registrations: "users/registrations"
  }
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
