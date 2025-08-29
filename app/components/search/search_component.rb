# frozen_string_literal: true

class Search::SearchComponent < ViewComponent::Base
  def initialize(
    name: "query",
    id: nil,
    placeholder: "Search",
    value: nil,
    icon_class: "fas fa-search",
    css_classes: {
      container: "flex flex-col sm:flex-row items-center justify-end gap-4 w-full md:max-w-lg w-full relative",
      icon_container: "absolute inset-y-0 left-0 flex items-center pl-3 pointer-events-none",
      icon: "text-[var(--gray-500)] cursor-pointer",
      input: "search block w-full pl-10 pr-4 py-2 text-sm font-medium text-lg text-gray-900 border border-gray-300 rounded-md bg-white focus:outline-none focus:ring-2 focus:ring-gray-600"
    },
    **html_options
  )
    @name = name
    @id = id || "#{name.parameterize}-search"
    @placeholder = placeholder
    @value = value
    @icon_class = icon_class
    @css_classes = css_classes
    @html_options = html_options
  end

  private

  attr_reader :name, :id, :placeholder, :value, :icon_class, :css_classes, :html_options
end
