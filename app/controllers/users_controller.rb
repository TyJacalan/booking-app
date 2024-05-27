class UsersController < ApplicationController
  before_action :set_user
  before_action :set_services, only: %i[show reviews]
  before_action :set_reviews, only: %i[show reviews]
  before_action :set_appointments, only: [:show]
  before_action :set_accepted_appointments, only: [:show]

  layout 'user'

  def index; end

  def show; end

  def reviews; end

  private

  def set_user
    @user = User.find(params[:id])
    authorize User, :show?
  end

  def set_services
    @all_services = @user.services
    @services = @user.services.page(params[:page]).per(5)
  end

  def set_reviews
    @all_reviews = Review.where(freelancer_id: @user.id)
    @reviews = Review.where(freelancer_id: @user.id).page(params[:page]).per(5)
    authorize User, :show?
  end

  def set_appointments
    @appointments = Appointment.where(freelancer_id: @user.id).page(params[:page]).per(5)
  end

  def set_accepted_appointments
    @accepted_appointments = Appointment.where(freelancer_id: @user.id, status: :accepted)
  end
end
