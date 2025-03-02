# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  before_action :configure_sign_up_params, only: %i[create create_freelancer]
  before_action :configure_account_update_params, only: [:update_freelancer]
  before_action :set_categories

  def new_freelancer
    unless current_user
      redirect_to new_user_session_path, alert: 'You must be logged in to become a freelancer'
      return
    end
    build_resource({})
    respond_with resource
  end

  def create_freelancer
    user = current_user
    role = Role.find_by(name: 'freelancer')
    user.role = role

    user.assign_attributes(sign_up_params)
    if user.valid?
      user.save!
      redirect_to root_path, notice: "Welcome to the freelancers' community!"
    else
      flash.now[:alert] = user.errors.full_messages.join(', ')
      render :new_freelancer, status: :unprocessable_entity
    end
  rescue ActiveRecord::RecordInvalid => e
    flash[:alert] = e.message
    redirect_to root_path
  end

  # POST /resource
  def create
    super do |resource|
      Users::UserRegistrationService.call(resource)
    end
  end

  def edit_freelancer
    self.resource = current_user
    respond_with resource
  end

  def update_freelancer
    self.resource = current_user
    resource.assign_attributes(account_update_params)

    if resource.save
      redirect_to user_path(resource), notice: 'Profile was successfully updated'
    else
      flash[:alert] = resource.errors.full_messages.join(', ')
      render :edit_freelancer
    end
  rescue ActiveRecord::RecordInvalid => e
    flash[:alert] = e.message
    redirect_to root_path
  end

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

  def set_categories
    @categories = Category.all
  end
end
