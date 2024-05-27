class UsersController < ApplicationController
  before_action :set_user, only: %i[show]
  before_action :set_services, only: %i[show]
  before_action :set_reviews, only: %i[show]
  before_action :set_appointments, only: [:show]
  before_action :set_accepted_appointments, only: [:show]

  layout :set_layout

  def index; end

  def show; end

  def reviews
    puts "these params: #{params}"
    @user = User.find(params[:user_id])
    if @user&.role&.name == 'freelancer'
      @all_reviews = Review.where(freelancer_id: @user.id)
      @reviews = Review.where(freelancer_id: @user.id).page(params[:page]).per(5)
    else
      @all_reviews = Review.where(client_id: @user.id)
      @reviews = Review.where(client_id: @user.id).page(params[:page]).per(5)
    end
    authorize User, :show?
    render 'reviews/_reviews'
  end

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
    if @user&.role&.name == 'freelancer'
      @all_reviews = Review.where(freelancer_id: @user.id)
      @reviews = Review.where(freelancer_id: @user.id).page(params[:page]).per(5)
    else
      @all_reviews = Review.where(client_id: @user.id)
      @reviews = Review.where(client_id: @user.id).page(params[:page]).per(5)
    end
    authorize User, :show?
  end

  def set_appointments
    @appointments = if @user&.role&.name == 'freelancer'
                      Appointment.where(freelancer_id: @user.id).page(params[:page]).per(5)
                    else
                      Appointment.where(client_id: @user.id).page(params[:page]).per(5)
                    end
  end

  def set_accepted_appointments
    @accepted_appointments = Appointment.where(freelancer_id: @user.id, status: :accepted)
  end

  def set_layout
    if user_signed_in?
      'user'
    else
      'application'
    end
  end
end
