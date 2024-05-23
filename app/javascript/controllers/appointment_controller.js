import { Controller } from '@hotwired/stimulus'
import flatpickr from 'flatpickr'

export default class extends Controller {
  static targets = ['dateInput',
                    'duration',
                    'durationInput',
                    'endDate', 
                    'fee',
                    'price',
                    'serviceFee',
                    'startDate',
                    'totalFee' ]

  connect() {
    flatpickr(this.dateInputTarget, {
      mode: 'range',
      minDate: this.dateInputTarget.value || new Date().fp_incr(1),
      onChange: (selectedDates) => {
        this.handleDateChange(selectedDates);
        this.handleDurationChange();
      },
    });

  }

  handleDateChange(selectedDates) {
    const startDate = selectedDates[0];
    const endDate = selectedDates[1];

    this.startDateTarget.value = selectedDates[0];
    this.endDateTarget.value = selectedDates[1];

    const totalHours = this.calculateTotalAvailableHours(startDate, endDate);
    this.updateDurationOptions(totalHours);

    
    this.updateDetails();
  }

  handleDurationChange(){
    this.durationInputTarget.addEventListener('change', () => {
      this.updateDetails();
    });
  }

  calculateTotalAvailableHours(startDate, endDate) {
    const minimumAvailableHours = 24;
    const dateDifference = endDate  - startDate;

    const millisecondsInAnHour = 1000 * 60 * 60;
    return Math.ceil( dateDifference / millisecondsInAnHour ) || minimumAvailableHours;
  }

  updateDurationOptions(totalHours) {
    this.durationInputTarget.innerHTML = '';
    for (let i = 1; i <= totalHours; i++) {
      const option = document.createElement('option');
      option.value = i;
      option.textContent = i;
      this.durationInputTarget.appendChild(option);
      
    }
  }

  updateDetails() {
    const duration = parseInt(this.durationInputTarget.value);
    const fee = parseInt(this.feeTarget.textContent);
    const price = duration * fee;
    const serviceFee = price * 0.025;
    const totalFee = price + serviceFee;

    this.durationTarget.textContent = duration;
    this.priceTarget.textContent = this.formatCurrency(price);
    this.serviceFeeTarget.textContent = this.formatCurrency(serviceFee);
    this.totalFeeTarget.textContent = this.formatCurrency(totalFee);
  }

  formatCurrency(value) {
    const formatter = new Intl.NumberFormat('en-PH', {
      style: 'currency',
      currency: 'PHP',
    });

    return formatter.format(value);
  }
}
