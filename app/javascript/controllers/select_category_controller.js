import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["hiddenField"];

  connect() {
    console.log('connected')
    this.selectedCategories = new Set(
      this.hiddenFieldTarget.value.split(",").filter(Boolean)
    );
  }

  toggleCategory(event) {
    event.preventDefault();
    const categoryId = event.currentTarget.dataset.categoryId;

    console.log(event.currentTarget.dataset)

    if (this.selectedCategories.has(categoryId)) {
      this.selectedCategories.delete(categoryId);
    } else {
      this.selectedCategories.add(categoryId);
    }

    // Update the hidden field value with the selected category IDs
    this.hiddenFieldTarget.value = Array.from(this.selectedCategories).join(",");
    
    // Toggle border classes for visual feedback
    event.currentTarget.classList.toggle("border-black");
    event.currentTarget.classList.toggle("border-transparent");

    console.log(this.hiddenFieldTarget.value)
  }
}
