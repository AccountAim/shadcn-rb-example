import { Controller } from "@hotwired/stimulus"

// Picks a shadcn-rb style by writing the cookie client-side, then reloading so
// the server re-renders every component with it.
//
// Deliberately not a POST: docs pages skip the session in production so they
// can be publicly cached (ApplicationController#set_public_cache_headers), and
// without a session Rails can't verify a CSRF token — the form 422'd on the
// deployed site while working locally. `reload()` revalidates, so the fresh
// HTML wins over the `public, max-age=3600` copy in the browser cache.
export default class extends Controller {
  static values = {
    cookie: String,
    maxAge: { type: Number, default: 31536000 }
  }

  apply({ params: { key } }) {
    const value = encodeURIComponent(key)
    document.cookie = `${this.cookieValue}=${value}; path=/; max-age=${this.maxAgeValue}; samesite=lax`
    window.location.reload()
  }
}
