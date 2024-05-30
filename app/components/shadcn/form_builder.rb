class Shadcn::FormBuilder < ActionView::Helpers::FormBuilder
  include ActionView::Helpers::TagHelper

  def label(method, options = {}, &block)
    options[:class] = @template.tw("#{options[:class]}")
    @template.render_label(
      name: "#{object_name}[#{method}]",
      label: label_for(@object, method),
      **options,
      &block
    )
  end

  def text_field(method, options = {})
    error_class = @object.errors[method].any? ? 'error' : ''
    options[:class] = @template.tw("#{options[:class]} #{error_class}")
    @template.render_input(
      name: "#{object_name}[#{method}]",
      id: "#{object_name}_#{method}",
      value: @object.send(method),
      type: 'text', **options
    )
  end

  def number_field(method, options = {})
    error_class = @object.errors[method].any? ? 'error' : ''
    options[:class] = @template.tw("#{options[:class]} #{error_class}")
    @template.render_input(
      name: "#{object_name}[#{method}]",
      id: "#{object_name}_#{method}",
      value: @object.send(method),
      type: 'number', **options
    )
  end

  def password_field(method, options = {})
    error_class = @object.errors[method].any? ? 'error' : ''
    options[:class] = @template.tw("#{options[:class]} #{error_class}")
    @template.render_input(
      name: "#{object_name}[#{method}]",
      id: "#{object_name}_#{method}",
      value: @object.send(method),
      type: 'password', **options
    )
  end

  def date_field(method, options = {})
    error_class = @object.errors[method].any? ? 'error' : ''
    options[:class] = @template.tw("#{options[:class]} #{error_class}")
    @template.render_input(
      name: "#{object_name}[#{method}]",
      id: "#{object_name}_#{method}",
      value: @object.send(method),
      type: 'date', **options
    )
  end

  def email_field(method, options = {})
    error_class = @object.errors[method].any? ? 'error' : ''
    options[:class] = @template.tw("#{options[:class]} #{error_class}")
    @template.render_input(
      name: "#{object_name}[#{method}]",
      id: "#{object_name}_#{method}",
      value: @object.send(method),
      type: 'email', **options
    )
  end

  def text_area(method, options = {}, &block)
    error_class = @object.errors[method].any? ? 'error' : ''
    options[:class] = @template.tw("#{options[:class]} #{error_class}")

    @template.render_textarea(
      name: "#{object_name}[#{method}]",
      id: "#{object_name}_#{method}",
      value: @object.send(method),
      **options,
      &block
    )
  end

  def select_field(method, options = {}, &block)
    error_class = @object.errors[method].any? ? 'error' : ''
    options[:class] = @template.tw("#{options[:class]} #{error_class}")

    select_html = @template.render_select(
      name: "#{object_name}[#{method}]",
      id: "#{object_name}_#{method}",
      selected: options[:selected],
      **options,
      &block
    )

    if block_given?
      select_html
    else
      select_html + hidden_field(method)
    end
  end

  def checkbox(method, options = {})
    label = options.key?(:label) ? options[:label] : nil
    @template.render_checkbox(
      name: "#{object_name}_#{method}",
      label:
    )
  end

  def submit(value = nil, options = {})
    @template.render_button(value, **options)
  end

  def error_message(method, options = {})
    return unless @object.errors[method].any?

    method_name = method.to_s.capitalize.gsub('_', ' ')
    error_message = @object.errors[method].to_sentence

    content_tag(:p, "#{method_name} #{error_message}",
                options.merge(class: 'text-destructive'))
  end

  private

  def label_for(object, method)
    return method.capitalize if object.nil?

    object.class.human_attribute_name(method)
  end
end
