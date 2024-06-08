import { Controller } from "@hotwired/stimulus"
import Carousel from '@stimulus-components/carousel'
import Swiper from 'swiper';

export default class extends Carousel {
  static targets = ["form", "container", "title", "description", "price"]

  connect() {
    this.initializeSwiper()
    this.updatePreview()
  }

  initializeSwiper() {
    this.swiper = new Swiper(this.element.querySelector('.swiper-container'), {})
  }

  next(event) {
    event.preventDefault()
    this.swiper.slideNext()
  }

  previous(event) {
    event.preventDefault()
    this.swiper.slidePrev()
  }

  submitForm(event) {
    // Check if the current slide is the last one
    if (this.swiper.isEnd) {
      // Trigger form submission
      const form = this.element.querySelector('form');
      form.submit();
    } else {
      // If not the last slide, proceed to the next slide
      this.next(event);
    }
  }

  updatePreview() {
    const titleValue = this.formTarget.querySelector("#service_title").value
    const descriptionValue = this.formTarget.querySelector("#service_description").value
    const priceValue = this.formTarget.querySelector("#service_price").value

    this.titleTarget.textContent = titleValue
    this.descriptionTarget.textContent = descriptionValue
    this.priceTarget.textContent = priceValue
  }

  get formTarget() {
    return this.element.closest("form")
  }
}
