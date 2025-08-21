class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # Require authentication for all controllers by default
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    # for sign up
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])

    # for account update (profile editing)
    devise_parameter_sanitizer.permit(:account_update, keys: [:name])
  end
end
