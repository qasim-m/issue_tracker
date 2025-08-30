# frozen_string_literal: true

class LinkComponent < ViewComponent::Base
  VARIANTS = {
    primary: "text-white border-2 border-transparent rounded-lg hover:border-[var(--gray-800)] hover:text-[var(--gray-800)] hover:bg-[#F5F7F8]",
    secondary: "bg-[var(--gray-600)] hover:bg-[var(--gray-800)] text-white border-transparent",
    outline: "bg-transparent text-[var(--gray-600)] hover:bg-[var(--gray-800)] hover:text-white font-bold border-2 border-[var(--gray-600)] hover:border-[var(--gray-800)]",
    icon_only: "bg-transparent text-[var(--gray-500)] hover:text-[var(--gray-800)] border-0"
  }.freeze
	
  SIZES = {
    xs: 'px-2.5 py-1.5 font-semibold text-xs',
    sm: 'px-3 py-2 font-semibold text-sm leading-4',
    md: 'px-4 py-2 font-semibold text-sm',
    lg: 'px-4 py-2 font-semibold text-base',
    xl: 'px-6 py-3 font-semibold text-base',
    logo: "text-3xl font-extrabold px-4 py-1.5"
  }.freeze

  def initialize(
    href:,
    variant: :primary,
    size: :md,
    full_width: false,
    icon: nil,
    icon_position: :left,
    **html_attributes
  )
    @href = href
    @variant = validate_variant(variant)
    @size = validate_size(size)
    @full_width = full_width
    @icon = icon
    @icon_position = icon_position.to_sym
    @html_attributes = html_attributes
  end

  def call
    link_to(href, **link_attributes) do
      link_content
    end
  end

  private

  attr_reader :href, :variant, :size, :full_width,
              :icon, :icon_position, :html_attributes

  def link_content
		return text_content unless icon.present?
		if icon_position == :right
				text_content + icon_content
		else
				icon_content + text_content
		end
	end

  def text_content
    content_tag(:span, content, class: nil)
  end

  def icon_content
    return unless icon.present?
    content_tag(:span, class: icon_spacing_classes) do
      case icon
      when String
        icon.html_safe
      else
        icon
      end
    end
  end

  def link_attributes
    html_attributes.merge(
      class: link_classes
    )
  end

  def link_classes
    [
      base_classes,
      VARIANTS[variant],
      SIZES[size],
      width_classes,
      html_attributes[:class]
    ].compact.join(' ')
  end

  def base_classes
    'inline-flex items-center justify-center rounded-md border ' \
    'focus:outline-none focus:ring-0 focus:ring-offset-0 ' \
    'transition-colors duration-300 ' \
    'hover:cursor-pointer'
  end

  def width_classes
    full_width ? 'w-full' : nil
  end

  def icon_spacing_classes
    return 'mr-0' unless content.present?
    case icon_position
    when :left then 'mr-1'
    when :right then 'ml-1'
    else 'mr-2'
    end
  end

  def validate_variant(variant)
    variant = variant.to_sym
    VARIANTS.key?(variant) ? variant : :primary
  end

  def validate_size(size)
    size = size.to_sym
    SIZES.key?(size) ? size : :md
  end
end
