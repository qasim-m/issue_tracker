import { Controller } from "@hotwired/stimulus";
import List from "list.js";
import 'flowbite'; // Import flowbite to ensure initFlowbite() is available

export default class extends Controller {
  static targets = ["tableBody"];

  connect() {
    this.initializeListJs();
  }

  disconnect() {
    if (this.list) {
      this.list.destroy()
    }
  }

  initializeListJs() {
    if (this.hasTableBodyTarget) {
      this.listJs = new List(this.element, {
        valueNames: ["title", "issue_number", "status", "assigned_to", 'created_at'],
        listClass: "tableBody",
        pagination: true, // You need to enable pagination here
        page: 10
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

    // update icon inside the clicked button
    const icon = button.querySelector("i")
    if (icon) {
      icon.className = newOrder === "asc"
        ? "fa-solid fa-arrow-up-wide-short"
        : "fa-solid fa-arrow-down-wide-short"
    }
  }

  cleanPaginationLinks() {
    initFlowbite();
    this.element.querySelectorAll(".pagination a").forEach((a) => {
      a.removeAttribute("href");   // remove `href`
      a.style.cursor = "pointer";  // keep pointer style
    });
  }
}
