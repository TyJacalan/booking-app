import { Controller } from "stimulus";

export default class extends Controller {
  static targets = ["star"];

  connect() {
    // Initialize the star rating based on the current value
    const currentValue = parseInt(this.data.get("value"));
    this.selectStar(currentValue);
  }

  select(event) {
    event.preventDefault();
    const value = parseInt(event.target.getAttribute("data-value"));
    this.selectStar(value);
  }

  selectStar(value) {
    this.starTargets.forEach((star, index) => {
      if (index < value) {
        star.classList.add("text-yellow-500"); // Example: Apply a yellow color for filled stars
      } else {
        star.classList.remove("text-yellow-500");
      }
    });

    // Update the hidden input value (if needed)
    const hiddenInput = document.getElementById(this.data.get("field-name"));
    if (hiddenInput) {
      hiddenInput.value = value;
    }
  }
}