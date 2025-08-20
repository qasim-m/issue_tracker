Rails.application.routes.draw do
  devise_for :users
  # Root: show all projects
  root "projects#index"

  # using shallow:
  # /projects/:project_id/issues for listing/creating issues
  # /issues/:id for show/edit/update/destroy (shorter URLs)
  resources :projects do
    resources :issues, shallow: true do
      resources :comments, only: [:create, :destroy]
    end
  end
end
