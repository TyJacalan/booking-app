class OverallServiceRatingsController < ApplicationController
    before_action :set_service
    after_action :verify_authorized, except: %i[show]

    #service/service_id/overall_service_rating
    def show
        @overall_service_rating = @service.overall_service_rating

        respond_to do |format|
            format.html { render partial: 'reviews/overall_service_rating', locals: { service: @service, overall_service_rating: @overall_service_rating } }
            format.json { render json: @overall_service_rating }
        end
    end

    private

    def set_service
        @service = Service.find(params[:service_id])
    end
end