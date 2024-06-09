import { Controller } from "@hotwired/stimulus"
import Carousel from '@stimulus-components/carousel'
import Swiper from 'swiper';

export default class extends Carousel {
  static targets = ["form", "container", "title", "description", "price"]

  connect() {
    this.initializeSwiper()
  }

  initializeSwiper() {
    this.swiper = new Swiper(this.element.querySelector('.swiper-container'), {})
  }

  next(event) {
    event.preventDefault()
    const currentIndex = this.swiper.activeIndex;
    const lastIndexBeforePreview = this.swiper.slides.length - 2; // The index before the last slide which is the preview

    const nextButton = document.getElementById('nextButton');
    const publishButton = document.getElementById('publishButton');

    if (currentIndex === lastIndexBeforePreview) {
      this.showPreview();
      publishButton.classList.remove('hidden');
      nextButton.classList.add('hidden');
    } else {
      publishButton.classList.add('hidden');
      nextButton.classList.remove('hidden');
    }

    this.swiper.slideNext()
  }

  previous(event) {
    event.preventDefault()
    this.swiper.slidePrev()
  }

  get formTarget() {
    return this.element.querySelector('form')
  }

  showPreview() {
    const form = this.formTarget;
    const preview = document.getElementById('preview');
    const previewTitle = document.getElementById('previewTitle');
    const previewDescription = document.getElementById('previewDescription');
    const previewPrice = document.getElementById('previewPrice');
    const previewCategories = document.getElementById('previewCategories');

    // Populate preview section with form data
    previewTitle.textContent = form.querySelector('#service_title').value;
    previewDescription.textContent = form.querySelector('#service_description').value;
    previewPrice.textContent = `₱${parseFloat(form.querySelector('#service_price').value).toFixed(2)}`;
    
    // Fetch and display category titles
    const categoryIds = form.querySelector('#selected_categories').value.split(',');

    this.fetchCategories(categoryIds).then(categories => {
      previewCategories.innerHTML = '';
      categories.forEach(category => {
        const categoryElement = document.createElement('div');
        categoryElement.textContent = category.title;
        previewCategories.appendChild(categoryElement);
      });
    });

    // Show the preview section
    preview.classList.remove('hidden');
  }

  // Function to fetch category details based on IDs
  async fetchCategories(categoryIds) {
    const response = await fetch(`/categories?ids=${categoryIds.join(',')}`);
    if (response.ok) {
      return await response.json();
    } else {
      console.error('Failed to fetch categories');
      return [];
    }
  }
}
