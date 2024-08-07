# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  # before_action :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  # def create
  #   super
  # end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  def after_sign_out_path_for(_resource_or_scope)
    request.referrer || root_path
  rescue StandardError
    root_path
  end

  def after_sign_in_path_for(resource_or_scope)
    stored_location = stored_location_for(resource_or_scope)
    if stored_location == new_appointment_path
      root_path
    else
      stored_location || root_path
    end
  end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end
end
