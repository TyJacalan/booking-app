import { Controller } from '@hotwired/stimulus';

export default class extends Controller {
  static targets = ['cardFields', 'paymentMethod'];

  connect() {
    this.toggleFields();
  }

  toggleFields() {
    const paymentMethod = this.paymentMethodTarget.value;
    if (paymentMethod === 'gcash' || paymentMethod === 'paymaya') {
      this.cardFieldsTarget.style.display = 'none';
    } else {
      this.cardFieldsTarget.style.display = 'flex';
    }
  }
}
