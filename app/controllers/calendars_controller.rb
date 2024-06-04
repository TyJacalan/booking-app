# frozen_string_literal: true

class CalendarsController < ApplicationController
  before_action :authenticate_user!

  def index
    @date = params[:date] ? Date.parse(params[:date]) : Date.today
    @appointments = Appointment.where(freelancer_id: current_user.id, start: @date.beginning_of_month.beginning_of_week..@date.end_of_month.end_of_week)
    @blocked_dates = current_user.blocked_dates
    authorize @blocked_dates
    authorize @appointments
  end

  def create
    @blocked_date = BlockedDate.new(blocked_date_params)
    authorize @blocked_date
  end

  def destroy
    @blocked_date = BlockedDate.find(params[:id])
    authorize @blocked_date
  end

  private

  def blocked_date_params
    params.require(:blocked_date).permit(:date)
  end
end
