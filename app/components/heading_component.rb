# app/components/heading_component.rb
# frozen_string_literal: true

class HeadingComponent < ViewComponent::Base
  # Define heading levels and their responsive classes
  HEADING_STYLES = {
    h1: {
      mobile: 'text-3xl',      # 24px on mobile
      tablet: 'md:text-4xl',   # 36px on tablet+
      desktop: 'lg:text-5xl'   # 48px on desktop+
    },
    h2: {
      mobile: 'text-2xl',       # 20px on mobile
      tablet: 'md:text-3xl',   # 30px on tablet+
      desktop: 'lg:text-4xl'   # 36px on desktop+
    },
    h3: {
      mobile: 'text-lg',       # 18px on mobile
      tablet: 'md:text-2xl',   # 24px on tablet+
      desktop: 'lg:text-3xl'   # 30px on desktop+
    },
    h4: {
      mobile: 'text-base',     # 16px on mobile
      tablet: 'md:text-xl',    # 20px on tablet+
      desktop: 'lg:text-2xl'   # 24px on desktop+
    },
    h5: {
      mobile: 'text-sm',       # 14px on mobile
      tablet: 'md:text-lg',    # 18px on tablet+
      desktop: 'lg:text-xl'    # 20px on desktop+
    },
    h6: {
      mobile: 'text-xs',       # 12px on mobile
      tablet: 'md:text-base',  # 16px on tablet+
      desktop: 'lg:text-lg'    # 18px on desktop+
    }
  }.freeze

  # Color variants
  COLOR_VARIANTS = {
		default: 'text-[var(--gray-800)]',
		dark: 'text-[var(--gray-900)]',
		primary: 'text-[var(--gray-600)]',
		secondary: 'text-[var(--gray-700)]',
		muted: 'text-[var(--gray-500)]',
		light: 'text-[var(--gray-400)]',
    red: 'text-red-700',
		white: 'text-white',
	}.freeze

  # Weight options
  FONT_WEIGHTS = {
    normal: 'font-normal',
    medium: 'font-medium',
    semibold: 'font-semibold',
    bold: 'font-bold',
    extrabold: 'font-extrabold'
  }.freeze

  def initialize(
    level: :h1,
    color: :default,
    weight: :bold,
    align: :left,
    responsive: true,
    margin_bottom: true,
    **html_attributes
  )
    @level = validate_level(level)
    @color = validate_color(color)
    @weight = validate_weight(weight)
    @align = align.to_sym
    @responsive = responsive
    @margin_bottom = margin_bottom
    @html_attributes = html_attributes
  end

	def call
		content_tag heading_tag, content, heading_attributes
	end

  private

  attr_reader :level, :color, :weight, :align, :responsive, :margin_bottom, :html_attributes

  def heading_tag
    level.to_s
  end

  def heading_classes
    classes = [
      base_classes,
      responsive_classes,
      COLOR_VARIANTS[color],
      FONT_WEIGHTS[weight],
      alignment_classes,
      margin_classes,
      html_attributes[:class]
    ].compact

    classes.join(' ')
  end

  def base_classes
    'leading-tight tracking-tight'
  end

  def responsive_classes
    return custom_size_classes unless responsive
    
    styles = HEADING_STYLES[level]
    [
      styles[:mobile],
      styles[:tablet],
      styles[:desktop]
    ].join(' ')
  end

  def custom_size_classes
    # If responsive is false, just use the base mobile size
    HEADING_STYLES[level][:mobile]
  end

  def alignment_classes
    case align
    when :left then 'text-left'
    when :center then 'text-center'
    when :right then 'text-right'
    when :justify then 'text-justify'
    else 'text-left'
    end
  end

  def margin_classes
    return unless margin_bottom
    
    case level
    when :h1 then 'mb-4 md:mb-6'
    when :h2 then 'mb-3 md:mb-4'
    when :h3 then 'mb-2 md:mb-3'
    when :h4, :h5, :h6 then 'mb-2'
    end
  end

  def heading_attributes
    html_attributes.merge(class: heading_classes)
  end

  def validate_level(level)
    level = level.to_sym
    HEADING_STYLES.key?(level) ? level : :h1
  end

  def validate_color(color)
    color = color.to_sym
    COLOR_VARIANTS.key?(color) ? color : :default
  end

  def validate_weight(weight)
    weight = weight.to_sym
    FONT_WEIGHTS.key?(weight) ? weight : :bold
  end
end