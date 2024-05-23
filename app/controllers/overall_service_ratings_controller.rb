class OverallServiceRatingsController < ApplicationController
    before_action :set_service

    #service/service_id/overall_service_rating
    def show
        @overall_service_rating = service.overall_service_rating

        respond_to do |format|
            format.js { render partial: 'reviews/overall_service_rating', locals: { overall_service_rating: @overall_service_rating }}
        end
    end

    private

    def set_service
        @service = Service.find(params[:service_id])
    end
end