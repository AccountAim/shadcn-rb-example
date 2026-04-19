import { Controller } from "@hotwired/stimulus"

// Toggles the docs column between a centered fixed width and the full inset.
// The cookie lets the layout render the chosen width on the next request, so
// the page never flashes the other one.
export default class extends Controller {
  static targets = ["content", "expand", "collapse"]
  static classes = ["fixed"]
  static values = { cookie: String, full: Boolean }

  toggle() {
    this.fullValue = !this.fullValue
    this.fixedClasses.forEach((name) => this.contentTarget.classList.toggle(name, !this.fullValue))
    this.expandTarget.toggleAttribute("hidden", this.fullValue)
    this.collapseTarget.toggleAttribute("hidden", !this.fullValue)
    document.cookie = `${this.cookieValue}=${this.fullValue ? "full" : "fixed"}; path=/; max-age=31536000; samesite=lax`
  }
}
