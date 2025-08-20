import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["form", "button"]

  connect() {
    // Ensure form is hidden and button is visible initially
    this.formTarget.classList.add("hidden")
    this.buttonTarget.classList.remove("hidden")
  }

  toggle() {
    if (this.formTarget.classList.contains("hidden")) {
      // Show form, hide button
      this.formTarget.classList.remove("hidden")
      this.buttonTarget.classList.add("hidden")

      // Focus the input
      const input = this.formTarget.querySelector("input, textarea")
      if (input) input.focus()
    } else {
      // Hide form, show button
      this.formTarget.classList.add("hidden")
      this.buttonTarget.classList.remove("hidden")
    }
  }

  hideForm() {
    // Hide form and show button after submit
    this.formTarget.classList.add("hidden")
    this.buttonTarget.classList.remove("hidden")
  }
}
