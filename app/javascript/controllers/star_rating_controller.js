// app/javascript/controllers/star_rating_controller.js

import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = [];

  connect() {
    console.log('Star rating controller connected');
  }

  select(event) {
    event.preventDefault();
    const star = event.currentTarget;
    const value = parseInt(star.getAttribute("data-value"));
    this.updateStarRating(value);
    console.log(value)
    // Find the corresponding radio button and update its value
    const label = star.closest("label");
    const forAttribute = label.getAttribute("for");
    const radioButton = document.getElementById(forAttribute);
    if (radioButton) {
      radioButton.checked = true;
      radioButton.dispatchEvent(new Event("change")); // Trigger change event to update UI
    }
    console.log(radioButton.checked)
  }

  updateStarRating(value) {
    // Update star visuals based on the selected value
    console.log(`Selected star rating: ${value}`);
    this.element.querySelectorAll("i").forEach((star, index) => {
      if (index < value) {
        star.classList.add("text-yellow-500"); // Apply a yellow color for filled stars
      } else {
        star.classList.remove("text-yellow-500");
      }
    });
  }
}
