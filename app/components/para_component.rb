# frozen_string_literal: true

class ParaComponent < ViewComponent::Base
  # Responsive styles for paragraphs (mobile → tablet → desktop)
  PARA_STYLES = {
    base: {
      mobile: 'text-sm',       # 14px
      tablet: 'md:text-base',  # 16px
      desktop: 'lg:text-lg'    # 18px
    },
    lead: {
      mobile: 'text-base',     # 16px
      tablet: 'md:text-lg',    # 18px
      desktop: 'lg:text-xl'    # 20px
    },
    small: {
      mobile: 'text-xs',       # 12px
      tablet: 'md:text-sm',    # 14px
      desktop: 'lg:text-base'  # 16px
    },
    extra_small: {
      mobile: 'text-xs',
      tablet: 'md:text-xs',
      desktop: 'lg:text-sm'
    }
  }.freeze

  COLOR_VARIANTS = HeadingComponent::COLOR_VARIANTS
  FONT_WEIGHTS = HeadingComponent::FONT_WEIGHTS

  def initialize(
    variant: :small,
    color: :default,
    weight: :bold,
    align: :left,
    responsive: true,
    margin_bottom: false,
    **html_attributes
  )
    @variant = validate_variant(variant)
    @color = validate_color(color)
    @weight = validate_weight(weight)
    @align = align.to_sym
    @responsive = responsive
    @margin_bottom = margin_bottom
    @html_attributes = html_attributes
  end

  def call
    content_tag(:p, content, para_attributes)
  end

  private

  attr_reader :variant, :color, :weight, :align, :responsive,
              :margin_bottom, :html_attributes

  def para_classes
    [
      base_classes,
      responsive_classes,
      COLOR_VARIANTS[color],
      FONT_WEIGHTS[weight],
      alignment_classes,
      margin_classes,
      html_attributes[:class]
    ].compact.join(' ')
  end

  def base_classes
    'leading-relaxed'
  end

  def responsive_classes
    # only mobile size if responsive disabled
    return PARA_STYLES[variant][:mobile] unless responsive
    styles = PARA_STYLES[variant]
    [
      styles[:mobile],
      styles[:tablet],
      styles[:desktop]
    ].join(' ')
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
    margin_bottom ? 'mb-4' : nil
  end

  def para_attributes
    html_attributes.merge(class: para_classes)
  end

  def validate_variant(variant)
    variant = variant.to_sym
    PARA_STYLES.key?(variant) ? variant : :base
  end

  def validate_color(color)
    color = color.to_sym
    COLOR_VARIANTS.key?(color) ? color : :default
  end

  def validate_weight(weight)
    weight = weight.to_sym
    FONT_WEIGHTS.key?(weight) ? weight : :normal
  end
end
