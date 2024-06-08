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
    if (this.swiper.isEnd) {
      this.submitForm(event);
    } else {
      this.swiper.slideNext()
    }
  }

  previous(event) {
    event.preventDefault()
    this.swiper.slidePrev()
  }

  async submitForm(event) {
    event.preventDefault()
    const form = this.formTarget

    // Get CSRF token from meta tags
    const csrfToken = document.head.querySelector("[name=csrf-token]").content

    // Include CSRF token in headers
    const headers = new Headers()
    headers.append("X-CSRF-Token", csrfToken)
    headers.append("Accept", "application/json")

    // Prepare form data
    const formData = new FormData(form)

    try {
      // Submit form using Fetch API
      const response = await fetch(form.action, {
        method: form.method,
        headers: headers,
        body: formData
      })

      if (response.ok) {
        const data = await response.json()
        this.showToast("Service was successfully created.", "notice")
        // Redirect to the newly created/updated service page
        window.location.href = data.redirect_path
      } else {
        // Handle form submission error
        const errorText = await response.text()
        this.showToast("Form submission failed: " + errorText, "alert")
        console.error("Form submission failed:", errorText)
      }
    } catch (error) {
      this.showToast("Error submitting form: " + error.message, "alert")
      console.error("Error submitting form:", error)
    }
  }

  async showToast(message, type) {
    const turboFrame = document.querySelector('turbo-frame[id="toasts"]')

    if (turboFrame) {
      const url = new URL(window.location.href)
      url.searchParams.set(type, message)

      const response = await fetch(url, {
        headers: {
          "Turbo-Frame": "toasts"
        }
      })

      if (response.ok) {
        const html = await response.text()
        turboFrame.innerHTML = html
      }
    }
  }

  get formTarget() {
    return this.element.querySelector('form')
  }
}
