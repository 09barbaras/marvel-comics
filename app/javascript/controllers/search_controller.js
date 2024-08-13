import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="search"
export default class extends Controller {
  static targets = ["input"];

  connect() {
    console.log("Search controller connected");
    this.inputTarget.addEventListener("keypress", this.submitOnEnter.bind(this));
  }

  disconnect() {
    this.inputTarget.removeEventListener("keypress", this.submitOnEnter.bind(this));
  }

  submitOnEnter(event) {
    if (event.key === "Enter") {
      event.preventDefault();
      this.element.requestSubmit();
    }
  }
}
