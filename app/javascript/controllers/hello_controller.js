import { Controller } from "@hotwired/stimulus"

export default class extends Controller {

  greet() {
    const element = this.nameTarget
    console.log(`hello`)
  }
}
