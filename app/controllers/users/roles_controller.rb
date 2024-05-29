class Users::RolesController < ApplicationController
  def update
    @user = User.find(params[:user_id])
    authorize @user

    new_role = toggle_role(@user)

    if @user.update(role: new_role)
      redirect_to root_path, notice: "Switched to #{new_role.name}"
    else
      redirect_to root_path, alert: 'Something went wrong'
    end
  end

  private

  def toggle_role(user)
    if user.role.name == 'freelancer'
      Role.find_by(name: 'client')
    else
      Role.find_by(name: 'freelancer')
    end
  end
end
