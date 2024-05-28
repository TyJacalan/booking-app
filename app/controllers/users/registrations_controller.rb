# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  before_action :configure_sign_up_params, only: %i[create create_freelancer]
  before_action :configure_account_update_params, only: [:update_freelancer]
  before_action :set_freelancer, only: %i[edit_freelancer update_freelancer]

  def new_freelancer
    build_resource({})
    respond_with resource
  end

  def create_freelancer
    if user_signed_in?
      current_user.update(sign_up_params)
      current_user.update(role: Role.find_by(name: 'freelancer'))
      redirect_to root_path, notice: "Welcome to the freelancers' community!"
    else
      user = User.find_by(email: sign_up_params[:email])
      if user
        user.update(sign_up_params)
        user.update(role: Role.find_by(name: 'freelancer'))
        sign_in(user)
      else
        build_resource(sign_up_params)
        resource.role = Role.find_by(name: 'freelancer')
        resource.save
        sign_in(resource)
      end
      redirect_to root_path, notice: "You have successfully joined the freelancers' community!"
    end
  end

  def edit_freelancer
    self.resource = current_user
    respond_with resource
  end

  def update_freelancer
    if @freelancer.update(account_update_params)
      redirect_to user_path(@freelancer), notice: 'Profile was successfully updated'
    else
      render :edit_freelancer
    end
  end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  protected

  # If you have extra params to permit, append them to the sanitizer.
  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys:
    %i[
      first_name last_name email password password_confirmation
      biography skills birthdate address city country mobile
    ])
  end

  # If you have extra params to permit, append them to the sanitizer.
  def configure_account_update_params
    devise_parameter_sanitizer.permit(:account_update, keys:
    %i[
      first_name last_name email password password_confirmation
      biography skills birthdate address city country mobile
    ])
  end

  private

  def set_freelancer
    @freelancer = User.find_by(id: current_user.id)
  end

  def account_update_params
    params.require(:user).permit(
      :first_name, :last_name, :email, :password, :password_confirmation,
      :biography, :skills, :birthdate, :address, :city, :country, :mobile
    )
  end

  def handle_user_not_found
    flash[:alert] = 'User not found'
    redirect_to root_path
  end

  # The path used after sign up.
  # def after_sign_up_path_for(resource)
  #   super(resource)
  # end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end
end
