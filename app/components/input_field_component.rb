# app/components/input_field_component.rb
# frozen_string_literal: true

class InputFieldComponent < ViewComponent::Base
  # Input types supported
  INPUT_TYPES = %w[
    text email password number tel url search
    date datetime-local time month week
    color file range hidden select textarea
  ].freeze

  # Size variants
  SIZES = {
    sm: 'px-2 py-1 text-xs',
    md: 'px-2 py-1 sm:px-3 sm:py-2 text-sm',  # <-- responsive version
    lg: 'px-3 py-2 sm:px-4 sm:py-3 text-base'
  }.freeze

  # State variants
	STATES = {
		default: 'border-[var(--gray-300)] focus:border-[var(--gray-600)] focus:ring-[var(--gray-600)]',
		error:   'border-red-500 focus:border-red-500 focus:ring-red-500'
	}.freeze

  def initialize(
    form_builder: nil,
    attribute: nil,
    type: :text,
    size: :md,
    state: :default,
    placeholder: nil,
    label: nil,
    help_text: nil,
    required: false,
    disabled: false,
    readonly: false,
    autocomplete: nil,
    wrapper_class: nil,
    show_errors: true,
    icon: nil,
    icon_position: :left, # :left or :right
    **html_attributes
  )
    @form_builder = form_builder
    @attribute = attribute&.to_sym
    @type = validate_type(type)
    @size = validate_size(size)
    @state = determine_state(state)
    @placeholder = placeholder
    @label = label
    @help_text = help_text
    @required = required
    @disabled = disabled
    @readonly = readonly
    @autocomplete = autocomplete
    @wrapper_class = wrapper_class
    @show_errors = show_errors
    @icon = icon
    @icon_position = icon_position.to_sym
    @html_attributes = html_attributes
  end

  def call
    content_tag(:div, class: wrapper_classes) do
        safe_join([
        render_label,
        render_input,
        render_help_text,
        render_error_messages
        ].compact)
    end
	end

  private

  attr_reader :form_builder, :attribute, :type, :size, :state, :placeholder, :label,
              :help_text, :required, :disabled, :readonly, :autocomplete,
              :wrapper_class, :show_errors, :html_attributes, :icon, :icon_position

	def render_label
		return unless show_label?

		content_tag(:label, for: input_attributes[:id], class: label_classes) do
			safe_join([label, required_indicator].compact)
		end
	end

  def render_input
    case type.to_s
    when "select"
      render_select
    when "textarea"
      render_textarea
    else
      if icon.present?
        content_tag(:div, class: "relative") do
          safe_join([icon_span, tag.input(**input_attributes_with_icon)])
        end
      else
        tag.input(**input_attributes)
      end
    end
  end

  def render_textarea
    rows = @html_attributes.delete(:rows) || 5

    if using_form_builder?
      form_builder.text_area(
        attribute,
        input_attributes.merge(rows: rows)
      )
    else
      tag.textarea(current_value, **input_attributes.merge(rows: rows))
    end
  end

	def render_help_text
		return unless show_help_text?
		content_tag(:p, help_text, class: help_text_classes)
	end

	def render_error_messages
		return # unless show_error_messages?
		# content_tag(:div, class: error_classes) do
		# 	error_messages.join(', ')
		# end
	end

  def render_select
    options = @html_attributes.delete(:options) || [] # pass via component
    prompt  = @html_attributes.delete(:prompt)

    if using_form_builder?
      form_builder.select(
        attribute,
        options,
        { prompt: prompt },
        input_attributes
      )
    else
      tag.select(**input_attributes) do
        options_for_select(options)
      end
    end
  end

  def wrapper_classes
    [
      'mb-0 sm:mb-4',
      wrapper_class
    ].compact.join(' ')
  end

  def label_classes
    classes = [
      'block text-xs sm:text-sm font-bold mb-1',
      required ? 'text-gray-900' : 'text-gray-700'
    ]
    
    classes << 'text-red-700' if has_errors?
    classes.join(' ')
  end

	def input_classes
		[
			base_input_classes,
			SIZES[size],
			STATES[effective_state],
			disabled ? 'bg-[var(--gray-100)] cursor-not-allowed' : 'bg-white',
			readonly ? 'bg-[var(--gray-100)]' : '',
			html_attributes[:class]
		].compact.join(' ')
	end

  def base_input_classes
    'block w-full rounded-md border shadow-sm ' \
    'focus:outline-none focus:ring-1 transition-colors duration-200'
  end

  def input_attributes
    attrs = html_attributes.except(:class)
    
    attrs.merge!(
      class: input_classes,
      type: type.to_s,
      placeholder: effective_placeholder,
      required: required,
      disabled: disabled,
      readonly: readonly,
      autocomplete: autocomplete
    ).compact
    
    # Add form-specific attributes if using form builder
    if using_form_builder?
      attrs[:id] ||= "#{form_builder.object_name}_#{attribute}"
      attrs[:name] ||= "#{form_builder.object_name}[#{attribute}]"
      attrs[:value] = current_value if current_value.present?
    end
    
    attrs
  end

  def effective_placeholder
    return placeholder if placeholder.present?
    return label if label.present? && !show_label?
    nil
  end

  def effective_state
    return :error if has_errors? && show_errors
    state
  end

  def current_value
    return nil unless using_form_builder? && attribute
    
    form_builder.object.public_send(attribute) if form_builder.object.respond_to?(attribute)
  end

  def has_errors?
    return false unless using_form_builder? && attribute && show_errors
    
    form_builder.object.errors[attribute].any?
  end

  def error_messages
    return [] unless has_errors?
    
    form_builder.object.errors[attribute]
  end

  def show_label?
    label.present?
  end

  def show_help_text?
    help_text.present?
  end

  def show_error_messages?
    has_errors? && show_errors
  end

  def using_form_builder?
    form_builder.present? && attribute.present?
  end

  def help_text_classes
    'mt-1 text-sm text-gray-500'
  end

  def error_classes
    'mt-1 text-sm text-red-600'
  end

  def required_indicator
    return unless required
    
    content_tag(:span, '*', class: 'text-red-500 ml-1')
  end

  def determine_state(provided_state)
    # Auto-detect error state if form builder is present
    return :error if has_errors? && show_errors
    validate_state(provided_state)
  end

  def icon_span
    position_classes = icon_position == :left ?
      "left-3" : "right-3"

    content_tag(:span,
      icon.html_safe,
      class: "absolute inset-y-0 #{position_classes} flex items-center text-gray-400 pointer-events-none"
    )
  end

  def input_attributes_with_icon
    attrs = input_attributes
    if icon_position == :left
      attrs[:class] += " pl-10"
    else
      attrs[:class] += " pr-10"
    end
    attrs
  end

  def validate_type(input_type)
    type_string = input_type.to_s
    INPUT_TYPES.include?(type_string) ? input_type.to_sym : :text
  end

  def validate_size(input_size)
    size_sym = input_size.to_sym
    SIZES.key?(size_sym) ? size_sym : :md
  end

  def validate_state(input_state)
    state_sym = input_state.to_sym
    STATES.key?(state_sym) ? state_sym : :default
  end
end