import CheckboxSelectAll from '@stimulus-components/checkbox-select-all'

export default class extends CheckboxSelectAll {
  connect() {
    super.connect()
    console.log('checkbox-select-all connected');

    // Get all checked checkboxes
    this.checked

    // Get all unchecked checkboxes
    this.unchecked
  }
}
