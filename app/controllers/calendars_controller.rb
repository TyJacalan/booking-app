# frozen_string_literal: true

class CalendarsController < ApplicationController
  def index
    @date = params[:date] ? Date.parse(params[:date]) : Date.today
    @appointments = Appointment.where(freelancer_id: current_user.id, start: @date.beginning_of_month.beginning_of_week..@date.end_of_month.end_of_week)
    @blocked_dates = current_user.blocked_dates
    @blocked_date = BlockedDate.new
    authorize @blocked_dates
    authorize @appointments
  end

  def create
    @blocked_date = current_user.blocked_dates.new(blocked_date_params)
    authorize @blocked_date

    if @blocked_date.save
      message = "Date successfully blocked. Clients can no longer book your services on #{@blocked_date.date.strftime("%b %d, %Y")}."
      handle_response_success(message)
    else
      message = @blocked_date.errors.full_messages.first.to_s
      handle_response_failure(message)
    end
  end

  def destroy
    @blocked_date = BlockedDate.find(params[:id])
    authorize @blocked_date

    if @blocked_date.destroy
      message = "Date successfully unblocked. Clients can now book your services on #{@blocked_date.date.strftime("%b %d, %Y")}."
      handle_response_success(message)
    else
      message = @blocked_date.errors.full_messages.first.to_s
      handle_response_failure(message)
    end
  end

  private

  def blocked_date_params
    params.require(:blocked_date).permit(:date, :user_id)
  end

  def handle_response_success(notice = nil)
    respond_to do |format|
      flash.now[:notice] = notice if notice.present?
      format.turbo_stream
    end
  end

  def handle_response_failure(alert = nil)
    respond_to do |format|
      flash.now[:alert] = alert if alert.present?
      format.turbo_stream
    end
  end
end
