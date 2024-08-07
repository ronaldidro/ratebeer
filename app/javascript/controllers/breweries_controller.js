import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["brewery", "name", "year", "active", "selection"];
  static values = { brewerylist: Object };

  change(event) {
    const selected = event.target.value
    const { data } = this.brewerylistValue
    const brewery = data.find(b => b.businessId === selected)
    if (brewery) {
      this.nameTarget.value = brewery.name
      this.yearTarget.value = Number(brewery.registrationDate.slice(0,4))
    } else {
      this.nameTarget.value = ""
      this.yearTarget.value = "" 
    }
  }

  reset() {
    this.breweryTarget.value = ""
    this.nameTarget.value = ""
    this.yearTarget.value = ""
    this.activeTarget.checked = false
  }
}