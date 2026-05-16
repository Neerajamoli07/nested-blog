import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { dismissAfter: Number }

  connect() {
    if (this.hasDismissAfterValue) {
      this.timeout = setTimeout(() => this.dismiss(), this.dismissAfterValue)
    }
  }

  disconnect() {
    if (this.timeout) clearTimeout(this.timeout)
  }

  dismiss() {
    this.element.remove()
  }
}
