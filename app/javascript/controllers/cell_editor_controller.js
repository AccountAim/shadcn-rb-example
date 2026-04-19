import { Controller } from "@hotwired/stimulus"

// Reference inline editor for the data grid docs. Named on the grid as
// `editor: "cell-editor"`, so the grid calls these by name; an app would
// load its editor from the server instead. Swaps the cell for an input.
export default class extends Controller {
  activate({ cell, via, key }) {
    if (cell.dataset.selectable === "false" || cell.querySelector("input")) return

    cell.dataset.original = cell.innerHTML
    const input = document.createElement("input")
    input.className = "w-full bg-transparent outline-none"
    input.value = via === "key" ? (key.length === 1 ? key : "") : cell.textContent.trim()
    cell.replaceChildren(input)
    input.focus()
    if (via !== "key") input.select()
  }

  commit({ cell }) {
    this.finish(cell, cell.querySelector("input")?.value)
  }

  cancel({ cell }) {
    this.finish(cell)
  }

  // Focus left mid-edit: this demo keeps the value; an app may discard.
  leave({ cell }) {
    this.finish(cell, cell.querySelector("input")?.value, { refocus: false })
  }

  // The original is taken before the swap: removing the input drops focus,
  // and the grid's reaction must find nothing left to finish.
  finish(cell, value = null, { refocus = true } = {}) {
    if (!("original" in cell.dataset)) return

    const original = cell.dataset.original
    delete cell.dataset.original
    cell.innerHTML = original
    if (value !== null) cell.textContent = value
    this.grid.stamp(cell.parentElement)
    if (refocus) this.grid.focusCell(cell)
  }

  get grid() {
    return this.application.getControllerForElementAndIdentifier(this.element, "shadcnrb--data-grid--component")
  }
}
