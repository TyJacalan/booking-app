class Users::RolesController < ApplicationController
  def update
    @user = User.find(params[:user_id])
    authorize @user

    new_role = toggle_role(@user)

    if @user.update(role: new_role)
      redirect_to root_path, notice: "Switched to #{new_role.name}"
    else
      Rails.logger.error("Error updating user role: #{@user.errors.full_messages.join(', ')}")
      redirect_to root_path, alert: 'Something went wrong'
    end
  end

  private

  def toggle_role(user)
    new_role = if user.role.name == 'freelancer'
      Role.find_by(name: 'client')
    else
      Role.find_by(name: 'freelancer')
    end

    unless new_role
      Rails.logger.error("Role not found: #{user.role.name}")
      raise ActiveRecord::RecordNotFound, "Role not found: #{user.role.name}"
    end

    new_role
  end
end
