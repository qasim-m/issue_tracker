import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["form", "buttonContainer"]

  connect() {
    // Ensure form is hidden and button is visible initially
    this.formTarget.classList.add("hidden")
    this.buttonContainerTarget.classList.remove("hidden")
  }
  
  toggle() {
    if (this.formTarget.classList.contains("hidden")) {
      // Show form, hide button
      this.formTarget.classList.remove("hidden")
      this.buttonContainerTarget.classList.add("hidden")

      // Focus the input
      const input = this.formTarget.querySelector("input, textarea")
      if (input) input.focus()
    } else {
      // Hide form, show button
      this.formTarget.classList.add("hidden")
      this.buttonContainerTarget.classList.remove("hidden")
    }
  }
}
