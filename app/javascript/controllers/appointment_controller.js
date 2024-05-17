import { Controller } from '@hotwired/stimulus'
import flatpickr from 'flatpickr'

// Connects to data-controller="appointment"
export default class extends Controller {
  static targets = ['startDate', 'endDate']

  connect() {
    flatpickr(this.startDateTargets, {
      minDate: new Date().fp_incr(1),
      onChange: (selectedDates, dateStr, instance) => {
        console.log(selectedDates)
        this.triggerEndDatePicker(selectedDates);
      },
    });

    this.updateDetails();
  }

  triggerEndDatePicker(startDate){
    flatpickr(this.endDateTarget, {
      minDate: new Date(startDate),
      onChange: (selectedDates, dateStr, instance) => {
      },
    });

    this.endDateTarget.click();
  }

  updateDetails(){
    // calculate total price 
    // add service fee
  }
}
