Rails.application.routes.draw do
  # Only generate login/logout routes
  devise_for :users, skip: [:passwords]

  devise_scope :user do
    unauthenticated do
      root to: "devise/sessions#new", as: :unauthenticated_root
    end
  end

  authenticated :user do
    root to: "projects#index", as: :authenticated_root
  end
  # using shallow:
  # /projects/:project_id/issues for listing/creating issues
  # /issues/:id for show/edit/update/destroy (shorter URLs)
  resources :projects do
    resources :issues, shallow: true do
      resources :comments, only: [:new, :create]
    end
  end
end
