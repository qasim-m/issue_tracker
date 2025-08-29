# frozen_string_literal: true

class ButtonComponent < ViewComponent::Base
  VARIANTS = {
    primary: "bg-[var(--gray-600)] hover:bg-[var(--gray-800)] text-white border-transparent",
    secondary: "bg-[var(--gray-200)] hover:bg-[var(--gray-300)] text-gray-900 border-transparent",
    outline: "bg-transparent text-white font-bold hover:bg-[var(--gray-200)] hover:text-[var(--gray-800)] border-2 border-[var(--gray-300)]",
    icon_only: "bg-transparent text-[var(--gray-500)] hover:text-[var(--gray-800)] border-0"
  }.freeze

  SIZES = {
    xs: 'px-2.5 py-1.5 font-medium text-xs',
    sm: 'px-3 py-2 font-bold text-sm leading-4',
    md: 'px-4 py-2 font-bold text-sm',
    lg: 'px-4 py-2 font-medium text-base',
    xl: 'px-6 py-3 font-medium text-base'
  }.freeze

  def initialize(
    variant: :primary,
    size: :md,
    type: 'button',
    full_width: false,
    icon: nil,
    icon_position: :left,
    **html_attributes
  )
    @variant = validate_variant(variant)
    @size = validate_size(size)
    @type = type
    @full_width = full_width
    @icon = icon
    @icon_position = icon_position.to_sym
    @html_attributes = html_attributes
  end

  def call
    content_tag :button, **button_attributes do
      button_content
    end
  end

  private

  attr_reader :variant, :size, :type, :full_width,
              :icon, :icon_position, :html_attributes

  def button_content
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

  def button_attributes
    normalized_data = html_attributes.delete(:data)&.transform_keys { |key| key.to_s.tr("_", "-") } || {}

    merged_classes = [button_classes, html_attributes.delete(:class)].compact.join(" ")

    html_attributes.merge(
      class: merged_classes,
      type: type,
      data: normalized_data
    )
  end

  def button_classes
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
    full_width? ? 'w-full' : nil
  end

  def icon_size_classes
    case size
    when :xs, :sm then 'h-4 w-4'
    when :md, :lg then 'h-5 w-5'
    when :xl then 'h-6 w-6'
    end
  end

  def icon_spacing_classes
    return 'mr-0' unless content.present?

    case icon_position
    when :left then 'mr-1'
    when :right then 'ml-1'
    when :center then 'mx-auto'
    else 'mx-auto'
    end
  end

  def full_width?
    full_width
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