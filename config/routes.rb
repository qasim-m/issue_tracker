Rails.application.routes.draw do
  # Only generate login/logout routes
  devise_for :users, skip: [:registrations, :passwords]
  # Root: show all projects
  root "projects#index"

  # using shallow:
  # /projects/:project_id/issues for listing/creating issues
  # /issues/:id for show/edit/update/destroy (shorter URLs)
  resources :projects do
    resources :issues, shallow: true do
      resources :comments, only: [:new, :create]
    end
  end
end
