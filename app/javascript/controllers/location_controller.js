import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ['input', 'frame']

  connect() {}

  updateSearchParam(event) {
    const query = this.inputTarget.value;
    const url = this.frameTarget.getAttribute('data-base-url').replace('__QUERY__', encodeURIComponent(query));
    this.frameTarget.setAttribute('src', url);
  }

  assignValue(event) {
    const cityName = event.currentTarget.dataset.cityName
    this.inputTarget.value = cityName
    const url = this.frameTarget.getAttribute('data-base-url').replace('__QUERY__', '__QUERY__');
    this.frameTarget.setAttribute('src', url);
  }
}
