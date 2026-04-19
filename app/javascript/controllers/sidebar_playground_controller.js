import { Controller } from "@hotwired/stimulus"

// Live playground for sidebar_test — swaps data attrs on the fly.
// Variants (floating/inset) require server re-render because gap + container
// widths differ per variant. Side + collapsible mode + state can all flip
// client-side.
export default class extends Controller {
  static targets = ["sidebar", "state"]

  connect() {
    this.updateStateLabel()
  }

  setCollapsible(event) {
    const mode = event.currentTarget.dataset.collapsible
    const sidebar = this.sidebarTarget.querySelector("[data-slot='sidebar']")
    if (!sidebar) return
    sidebar.dataset.configuredCollapsible = mode
    if (this.sidebarTarget.dataset.state === "collapsed") {
      sidebar.dataset.collapsible = mode
    }
    this.markSelected("collapsible", mode)
    this.updateStateLabel()
  }

  setSide(event) {
    const side = event.currentTarget.dataset.side
    const sidebar = this.sidebarTarget.querySelector("[data-slot='sidebar']")
    if (sidebar) sidebar.dataset.side = side
    this.markSelected("side", side)
    this.updateStateLabel()
  }

  toggle() {
    const wrapper = this.sidebarTarget
    const next = wrapper.dataset.state === "expanded" ? "collapsed" : "expanded"
    wrapper.dataset.state = next
    const detector = wrapper.querySelector("[data-shadcnrb--sidebar-target='detector']")
    const isDesktop = !detector || getComputedStyle(detector).display !== "none"
    const inner = wrapper.querySelector("[data-slot='sidebar']")
    if (inner) {
      inner.dataset.state = next
      const configured = inner.dataset.configuredCollapsible || "offcanvas"
      const mode = isDesktop ? configured : "offcanvas"
      inner.dataset.collapsible = next === "collapsed" ? mode : ""
    }
    if (isDesktop) localStorage.setItem("sidebar-state", next)
    this.updateStateLabel()
  }

  markSelected(group, value) {
    this.element.querySelectorAll(`[data-${group}]`).forEach(btn => {
      btn.dataset.selected = (btn.dataset[group] === value).toString()
    })
  }

  updateStateLabel() {
    if (!this.hasStateTarget) return
    const wrapper = this.sidebarTarget
    const inner = wrapper.querySelector("[data-slot='sidebar']")
    const state = wrapper.dataset.state || "expanded"
    const mode = inner?.dataset?.configuredCollapsible || "offcanvas"
    const side = inner?.dataset?.side || "left"
    const variant = inner?.dataset?.variant || "sidebar"
    this.stateTarget.textContent = `state=${state} · mode=${mode} · side=${side} · variant=${variant}`
  }
}
