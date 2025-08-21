# Pin npm packages by running ./bin/importmap

pin "application"
pin "@hotwired/turbo-rails", to: "turbo.min.js"
pin "@hotwired/stimulus", to: "stimulus.min.js"
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js"
pin_all_from "app/javascript/controllers", under: "controllers"
# UI libs
pin "flowbite", to: "https://cdn.jsdelivr.net/npm/flowbite@3.1.2/dist/flowbite.turbo.min.js"
# config/importmap.rb
pin "list.js", to: "https://esm.sh/list.js@2.3.1"
pin "string-natural-compare", to: "https://cdn.jsdelivr.net/npm/string-natural-compare@3.0.1/index.js"
# Optional: FontAwesome (JS version, if needed)
pin "@fortawesome/fontawesome-free", to: "https://cdn.jsdelivr.net/npm/@fortawesome/fontawesome-free@6.5.2/js/all.min.js"
