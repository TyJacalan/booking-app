import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["hiddenField"];

  connect() {
    // Split the hidden field value by commas and filter out empty strings
    this.selectedCategories = new Set(
      this.hiddenFieldTarget.value.split(",").filter(Boolean)
    );
  }

  toggleCategory(event) {
    event.preventDefault();
    const categoryId = event.currentTarget.dataset.categoryId;

    // Check if the category ID is already in the hidden field value
    const hiddenFieldValue = this.hiddenFieldTarget.value;
    const categoryIdsArray = hiddenFieldValue.split(',').filter(Boolean); // Filter out empty strings

    const categoryIndex = categoryIdsArray.indexOf(categoryId);

    if (categoryIndex !== -1) {
      // Remove the category ID if it already exists
      categoryIdsArray.splice(categoryIndex, 1);
    } else {
      // Add the category ID if it doesn't exist
      categoryIdsArray.push(categoryId);
    }

    // Update the hidden field value
    this.hiddenFieldTarget.value = categoryIdsArray.join(',');
    
    // Toggle border classes for visual feedback
    event.currentTarget.classList.toggle("border-black");
    event.currentTarget.classList.toggle("border-transparent");
  }
}
