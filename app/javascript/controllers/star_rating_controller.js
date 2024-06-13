// app/javascript/controllers/star_rating_controller.js

import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = [];

  connect() {
    const selectedRadioButton = this.element.querySelector("input[type='radio']:checked");
    const value = parseInt(selectedRadioButton.value);
    this.updateStarRatingConnect(value);
    console.log(value)
  }

  select(event) {
    event.preventDefault();
    const star = event.currentTarget;
    const value = parseInt(star.getAttribute("data-value"));
    this.updateStarRating(value);

    const label = star.closest("label");
    const forAttribute = label.getAttribute("for");
    const radioButton = document.getElementById(forAttribute);
    if (radioButton) {
      radioButton.checked = true;
      radioButton.dispatchEvent(new Event("change"));
    }
  }

  updateStarRatingConnect(value) {
    console.log(value)
    this.element.querySelectorAll("i").forEach((star, index) => {
      console.log(123)
      const index_new = (index - 4) * (-1)
      if (index_new < value) {
        star.classList.add("yellow-star"); 
        value -= 1
      } else {
        star.classList.remove("yellow-star");
      }
    });
  }

  updateStarRating(value) {
    console.log(value)
    this.element.querySelectorAll("svg").forEach((star, index) => {
      console.log(123)
      const index_new = (index - 4) * (-1)
      if (index_new < value) {
        star.classList.add("yellow-star"); 
        value -= 1
      } else {
        star.classList.remove("yellow-star");
      }
    });
  }
}