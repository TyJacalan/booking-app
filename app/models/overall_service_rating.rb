class OverallServiceRating < ApplicationRecord
    include ActionView::RecordIdentifier

    belongs_to :service
    after_update :broadcast_rating_update

    private

    def broadcast_rating_update
        Rails.logger.info "Broadcasting with target: overall_service_rating_service_#{service.id}_container"
        broadcast_replace_to(
          service, :overall_service_rating,
          target: dom_id(service, :overall_service_rating),
          partial: 'reviews/overall_service_rating',
          locals: { service: service, overall_service_rating: self }
        )

        broadcast_replace_to(
          service, :overall_service_rating_modal,
          target: dom_id(service, :overall_service_rating),
          partial: 'reviews/overall_service_rating',
          locals: { service: service, overall_service_rating: self }
        )
    end
end
