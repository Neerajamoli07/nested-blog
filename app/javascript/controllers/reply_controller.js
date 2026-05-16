import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "form" ]

  toggle(event) {
    event.preventDefault()
    this.formTarget.hidden = !this.formTarget.hidden
    this.formTarget.classList.toggle("is-hidden", this.formTarget.hidden)
    if (!this.formTarget.hidden) {
      this.formTarget.querySelector("textarea")?.focus()
    }
  }

  cancel(event) {
    event.preventDefault()
    this.formTarget.hidden = true
    this.formTarget.classList.add("is-hidden")
    const textarea = this.formTarget.querySelector("textarea")
    if (textarea) textarea.value = ""
  }
}
