import { Controller } from "@hotwired/stimulus";
import List from "list.js";
import 'flowbite'; // Import flowbite to ensure initFlowbite() is available

export default class extends Controller {
  static targets = ["list"];

  connect() {
    // connects on page render
    this.initializeListJs();
  }

  disconnect() {
    if (this.list) {
      this.list.destroy()
    }
  }

  initializeListJs() {
    if (this.hasListTarget) {
      this.listJs = new List(this.element, {
        valueNames: ["title", "num"],
        listClass: "list",
        page: 10,
        pagination: true,
      });

      // After List.js initializes
      initFlowbite();

      // Re-clean every time pagination updates
      this.cleanPaginationLinks();
      this.listJs.on("updated", () => this.cleanPaginationLinks());
    }
  }

  sort(event) {
    const button = event.currentTarget
    const field = button.dataset.sort
    const currentOrder = this.currentSort?.[field] || "asc"
    const newOrder = currentOrder === "asc" ? "desc" : "asc"

    this.listJs.sort(field, { order: newOrder })
    this.currentSort = { ...this.currentSort, [field]: newOrder }
  }

  cleanPaginationLinks() {
    initFlowbite();
    this.element.querySelectorAll(".pagination a").forEach((a) => {
      a.removeAttribute("href");   // remove href
      a.style.cursor = "pointer";  // keep pointer style
    });
  }
}
