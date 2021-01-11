class ApplicationController < ActionController::Base
before_action :authenticate_user!
skip_before_action :verify_authenticity_token

  include Pundit

  # Pundit: white-list approach.
  after_action :verify_authorized, except: :index, unless: :skip_pundit?
  after_action :verify_policy_scoped, only: :index, unless: :skip_pundit?
  before_action :configure_permitted_parameters, if: :devise_controller?

# DeleteGroups.flush
  def default_url_options
    { host: ENV["DOMAIN"] || "localhost:3000" }
  end

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  def user_not_authorized
    flash[:alert] = "No estas autorizado/a para completar esta acción"
    redirect_to(root_path)
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name, :user_name])
    devise_parameter_sanitizer.permit(:sign_in, keys: [:user_name])
    devise_parameter_sanitizer.permit(:account_update, keys: [:first_name, :last_name, :username])
  end


  private

  def skip_pundit?
    devise_controller? || params[:controller] =~ /(^(rails_)?admin)|(^pages$)|(^passthrough$)|(^days$)|(^orders$)/
  end
end
