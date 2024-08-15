import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["favoriteIcon"];

  connect() {
    console.log("Comics controller connected");
  }

  // Handle icon change on hover 
  hover(event) {
    const hoverSrc = event.target.dataset.hoverSrc;
    event.target.src = hoverSrc;
  }

  unhover(event) {
    const offSrc = event.target.dataset.offSrc;
    event.target.src = offSrc;
  }
}
