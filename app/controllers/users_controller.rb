class UsersController < ApplicationController
  before_action :set_user
  before_action :set_services, only: %i[show reviews]
  before_action :set_reviews, only: %i[show reviews]
  before_action :set_appointments, only: [:show]
  before_action :set_accepted_appointments, only: [:show]

  layout 'user'

  def index; end

  def show
    authorize User
  end

  def reviews; end

  private

  def set_user
    if current_user
      @user = User.find_by(id: current_user.id)
      return @user if @user
    end
    redirect_to root_path
  end

  def set_services
    @services = current_user.services if current_user&.role&.name == 'freelancer'
  end

  def set_reviews
    @reviews = if current_user&.role&.name == 'freelancer'
                 Review.where(freelancer_id: current_user.id).page(params[:page]).per(5)
               else
                 Review.where(client_id: current_user.id).page(params[:page]).per(5)
               end
    authorize User, :show?
  end

  def set_appointments
    @appointments = if current_user&.role&.name == 'freelancer'
                      Appointment.where(freelancer_id: current_user.id).page(params[:page]).per(5)
                    else
                      Appointment.where(client_id: current_user.id).page(params[:page]).per(5)
                    end
  end

  def set_accepted_appointments
    @accepted_appointments = Appointment.where(freelancer_id: current_user.id, status: :accepted)
  end
end
