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
        valueNames: ["title", "issue_number", "status", "assigned_to"],
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

  cleanPaginationLinks() {
    initFlowbite();
    this.element.querySelectorAll(".pagination a").forEach((a) => {
      a.removeAttribute("href");   // remove `href`
      a.style.cursor = "pointer";  // keep pointer style
    });
  }
}
