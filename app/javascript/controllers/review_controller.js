import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="review"
export default class extends Controller {
  static target = ["overall_rating", "reviews"]
  connect() {
    this.getOverallServiceRating;
    this.getReviews;
  };
  
  async getOverallServiceRating() {
    url = service/{service_id}/overall_service_rating
    fetch(url, { headers: { 'Accept': 'text/javascript' } })
    .then(response => response.text())
    .then(html => {
      document.getElementById('reviews-modal-content').innerHTML = html;
      dialog.open();
    });
  }
}
