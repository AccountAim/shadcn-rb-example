import { Controller } from "@hotwired/stimulus"

// Persists shadcnrb preferences on the server: the theme switcher and the
// sidebar dispatch `change` events with the new value, and `save` PATCHes
// the event detail as-is. The cookies they also write cover a failed request
// until the next server render, where the stored value wins.
export default class extends Controller {
  static values = { url: String }

  save({ detail }) {
    fetch(this.urlValue, {
      method: "PATCH",
      headers: {
        "Content-Type": "application/json",
        "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').content
      },
      body: JSON.stringify(detail)
    })
  }
}
