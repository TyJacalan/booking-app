class UsersController < ApplicationController
  before_action :set_user, only: %i[show reviews services]
  before_action :load_resources, only: %i[show]

  def index; end

  def show; end

  def reviews
    @reviews = paginated_reviews
    render 'reviews/_reviews'
  end

  def services
    @services = @user.services
    render 'services/_services'
  end

  private

  def set_user
    @user = User.find(params[:id] || params[:user_id])
    authorize @user, :show?
  end

  def load_resources
    set_services
    set_reviews
    set_appointments
    set_accepted_appointments
  end

  def set_services
    @all_services = @user.services
    @services = @all_services.page(params[:page]).per(5)
  end

  def set_reviews
    @all_reviews = fetch_reviews
    @reviews = @all_reviews.page(params[:page]).per(5)
  end

  def fetch_reviews
    if freelancer?
      Review.where(freelancer_id: @user.id)
    else
      Review.where(client_id: @user.id)
    end
  end

  def paginated_reviews
    fetch_reviews.page(params[:page]).per(5)
  end

  def set_appointments
    @appointments = fetch_appointments.page(params[:page]).per(5)
  end

  def fetch_appointments
    if freelancer?
      Appointment.where(freelancer_id: @user.id)
    else
      Appointment.where(client_id: @user.id)
    end
  end

  def set_accepted_appointments
    @accepted_appointments = Appointment.where(freelancer_id: @user.id, status: :accepted)
  end

  def freelancer?
    @user&.role&.name == 'freelancer'
  end
end
