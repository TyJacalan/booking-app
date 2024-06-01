class ApplicationController < ActionController::Base
  include Pundit::Authorization
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?

  after_action :verify_authorized, unless: :devise_controller?

  # Rescue Pundit errors
  rescue_from Pundit::NotAuthorizedError do |e|
    Rails.logger.error("Authorization failed: #{e.policy.class} #{e.query}")
    redirect_to root_path, alert: "Unauthorized access: #{e.policy.class} #{e.query.to_s.humanize}"
  end

  private

  def user_not_authorized
    flash[:alert] = 'You are not authorized to perform this action'
    redirect_to(request.referrer || root_path)
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[first_name last_name])
    devise_parameter_sanitizer.permit(:account_update, keys: %i[first_name last_name])
  end
end
