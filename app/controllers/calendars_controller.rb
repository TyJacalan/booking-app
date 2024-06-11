# frozen_string_literal: true

class CalendarsController < ApplicationController
  before_action :authenticate_user!
  before_action :block_past_dates, only: :index

  def index
    @date = params[:date] ? Date.parse(params[:date]) : Date.today
    @appointments = Appointment.where(freelancer_id: current_user.id,
                                      start: @date.beginning_of_month.beginning_of_week..@date.end_of_month.end_of_week)
    @blocked_dates = current_user.blocked_dates
    @blocked_date = BlockedDate.new

    authorize @blocked_dates
    authorize @appointments
  end

  def create
    @blocked_date = current_user.blocked_dates.new(blocked_date_params)
    authorize @blocked_date

    if @blocked_date.save
      message = "Date successfully blocked. Clients can no longer book your services on #{@blocked_date.date.strftime('%b %d, %Y')}."
      handle_response_success(message)
    else
      message = @blocked_date.errors.full_messages.first.to_s
      handle_response_failure(message)
    end
  end

  def destroy
    @blocked_date = BlockedDate.find(params[:id])
    past_dates = (Date.today.beginning_of_year..Date.yesterday)
    authorize @blocked_date

    if past_dates.cover?(@blocked_date.date)
      redirect_to calendars_path, alert: 'Cannot unblock dates from the past'
      return
    end

    if @blocked_date.destroy
      message = "Date successfully unblocked. Clients can now book your services on #{@blocked_date.date.strftime('%b %d, %Y')}."
      handle_response_success(message)
    else
      message = @blocked_date.errors.full_messages.first.to_s
      handle_response_failure(message)
    end
  end

  private

  def block_past_dates
    past_dates = (Date.today.beginning_of_year..Date.yesterday)
    past_dates.each do |date|
      current_user.blocked_dates.create!(date:) unless BlockedDate.exists?(date:, user: current_user)
    end
  end

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
