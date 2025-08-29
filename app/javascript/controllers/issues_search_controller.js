import { Controller } from "@hotwired/stimulus";
import List from "list.js";
import 'flowbite'; // Import flowbite to ensure initFlowbite() is available

export default class extends Controller {
  static targets = ["tableBody", "search"];

  connect() {
    this.initializeListJs();
    this.searchTarget.addEventListener("input", this.customSearch.bind(this));
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

  customSearch(event) {
    const query = event.target.value.trim().toLowerCase();

    if (query === "") {
      // Show all items if query is empty
      this.listJs.filter(() => true);
    } else {
      this.listJs.filter(item => {
        return ["title", "issue_number", "status", "assigned_to", "created_at"].some(field => {
          const value = (item.values()[field] || "").toString().toLowerCase();
          return (
            value === query ||               // exact match
            value.startsWith(query) ||       // begins with query
            value.includes(query)            // contains query anywhere
          );
        });
      });
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
