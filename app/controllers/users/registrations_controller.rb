# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  before_action :configure_sign_up_params, only: %i[create create_freelancer]
  before_action :configure_account_update_params, only: [:update_freelancer]

  def new_freelancer
    @categories = Category.all
    build_resource({})
    respond_with resource
  end

  def create_freelancer
    user = current_user
    user.assign_attributes(sign_up_params)
    if user.valid?
      user.save!
      role = Role.find_by(name: 'freelancer')
      user.update!(role_id: role.id)
      redirect_to root_path, notice: "Welcome to the freelancers' community!"
    else
      flash[:alert] = user.errors.full_message.join(', ')
      render :new_freelancer
    end
  rescue ActiveRecord::RecordInvalid => e
    flash[:alert] = e.message
    redirect_to root_path
  end

  # GET /resource/sign_up
  # def new
  #   super
  # end

  # POST /resource
  def create
    super do |resource|
      UserRegistrationService.call(resource)
    end
  end

  # GET /resource/edit
  # def edit
  #   super
  # end

  # PUT /resource
  # def update
  #   super
  # end

  def edit_freelancer
    self.resource = current_user
    respond_with resource
  end

  def update_freelancer
    user = current_user
    if user.update(account_update_params)
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
    [
      :first_name, :last_name, :email, :password, :password_confirmation,
      :biography, { skills: [] }, :birthdate, :address, :city, :country, :mobile, :role_id
    ])
  end

  # If you have extra params to permit, append them to the sanitizer.
  def configure_account_update_params
    devise_parameter_sanitizer.permit(:account_update, keys:
    [
      :first_name, :last_name, :email, :password, :password_confirmation,
      :biography, { skills: [] }, :birthdate, :address, :city, :country, :mobile
    ])
  end

  private

  def account_update_params
    params.require(:user).permit(
      :first_name, :last_name, :email, :password, :password_confirmation,
      :biography, { skills: [] }, :birthdate, :address, :city, :country, :mobile
    )
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
