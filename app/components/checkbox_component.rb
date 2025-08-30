# frozen_string_literal: true

class CheckboxComponent < ViewComponent::Base
  # Size variants
  SIZES = {
    sm: {
      checkbox: 'h-3 w-3',
      label: 'text-xs',
      spacing: 'ml-1'
    },
    md: {
      checkbox: 'h-4 w-4',
      label: 'text-sm',
      spacing: 'ml-2'
    },
    lg: {
      checkbox: 'h-5 w-5',
      label: 'text-base',
      spacing: 'ml-3'
    }
  }.freeze

  # Color variants for checked state
  COLOR_VARIANTS = {
		default:   'text-[var(--gray-600)] focus:ring-[var(--gray-600)]',
		primary:   'text-[var(--gray-800)] focus:ring-[var(--gray-800)]',
		secondary: 'text-[var(--gray-500)] focus:ring-[var(--gray-500)]'
	}.freeze

  # Label positions
  LABEL_POSITIONS = %i[right left top bottom].freeze

  def initialize(
    form_builder: nil,
    attribute: nil,
    label: nil,
    checked: false,
    size: :md,
    color: :primary,
    label_position: :right,
    required: false,
    wrapper_class: nil,
    label_class: nil,
    **html_attributes
  )
    @form_builder = form_builder
    @attribute = attribute&.to_sym
    @label = label
    @checked = checked
    @size = validate_size(size)
    @color = validate_color(color)
    @label_position = validate_label_position(label_position)
    @required = required
    @wrapper_class = wrapper_class
    @label_class = label_class
    @html_attributes = html_attributes
  end

	def call
		content_tag(:div, class: wrapper_classes) do
			safe_join([
				(tag.input(**hidden_field_attributes) if using_form_builder?),
				tag.input(**checkbox_attributes),
				(content_tag(:label, label + (required_indicator || ""), **label_attributes) if show_label?)
			].compact)
		end
	end

  private

  attr_reader :form_builder, :attribute, :label, :checked, :size, :color, :label_position,
              :required, :wrapper_class, :label_class, :html_attributes

  def wrapper_classes
    base_classes = case label_position
                   when :right then 'flex items-start'
                   when :left then 'flex items-start flex-row-reverse'
                   when :top then 'flex flex-col'
                   when :bottom then 'flex flex-col-reverse'
                   end

    [
      base_classes,
      'mb-2',
      wrapper_class
    ].compact.join(' ')
  end

  def checkbox_classes
    [
      base_checkbox_classes,
      size_classes[:checkbox],
      COLOR_VARIANTS[color],
      html_attributes[:class]
    ].compact.join(' ')
  end

	def base_checkbox_classes
		"rounded text-[var(--gray-600)] focus:ring-[var(--gray-600)] border-gray-300"
	end

  def label_classes
    [
      'cursor-pointer select-none',
      size_classes[:label],
      spacing_classes,
      required ? 'font-medium' : 'font-normal',
      label_class
    ].compact.join(' ')
  end

  def checkbox_attributes
    attrs = html_attributes.except(:class)
    base_attrs = {
      type: 'checkbox',
      class: checkbox_classes,
      required: required
    }

    # Handle checked state
    if using_form_builder?
      # Let Rails handle the checked state for form builder
      base_attrs[:checked] = current_checked_value if current_checked_value
    else
      base_attrs[:checked] = checked
      base_attrs[:value] = '1' # Standard Rails checkbox value
    end

    # Add form-specific attributes
    if using_form_builder?
      base_attrs[:id] ||= checkbox_id
      base_attrs[:name] ||= checkbox_name
    end

    attrs.merge(base_attrs).compact
  end

  def label_attributes
    attrs = {
      class: label_classes
    }
    # Associate label with checkbox
    if using_form_builder? || html_attributes[:id]
      attrs[:for] = checkbox_id
    end

    attrs
  end

  def checkbox_id
    if using_form_builder?
      "#{form_builder.object_name}_#{attribute}"
    else
      html_attributes[:id] || "checkbox_#{SecureRandom.hex(4)}"
    end
  end

  def checkbox_name
    if using_form_builder?
      "#{form_builder.object_name}[#{attribute}]"
    else
      html_attributes[:name]
    end
  end

  def current_checked_value
    return nil unless using_form_builder? && attribute
    return nil unless form_builder.object.respond_to?(attribute)
    form_builder.object.public_send(attribute)
  end

  def size_classes
    SIZES[size]
  end

  def spacing_classes
    return '' if label_position.in?([:top, :bottom])
    case label_position
    when :right then size_classes[:spacing]
    when :left then "mr-2" # Fixed spacing for left positioning
    end
  end

  def show_label?
    label.present?
  end

  def using_form_builder?
    form_builder.present? && attribute.present?
  end

  def required_indicator
    return unless required && show_label?
    content_tag(:span, '*', class: 'text-red-500 ml-1')
  end

  def validate_size(input_size)
    size_sym = input_size.to_sym
    SIZES.key?(size_sym) ? size_sym : :md
  end

  def validate_color(input_color)
    color_sym = input_color.to_sym
    COLOR_VARIANTS.key?(color_sym) ? color_sym : :primary
  end

  def validate_label_position(position)
    pos_sym = position.to_sym
    LABEL_POSITIONS.include?(pos_sym) ? pos_sym : :right
  end

  # Hidden field for unchecked state (Rails convention)
  def hidden_field_attributes
    return {} unless using_form_builder?
    {
      type: 'hidden',
      name: checkbox_name,
      value: '0'
    }
  end
end