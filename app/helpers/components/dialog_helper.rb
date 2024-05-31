module Components::DialogHelper
  def render_dialog(**options, &block)
    content = capture(&block) if block
    options[:class] ||= ''
    options[:dialog_class] ||= '' # Custom class for the dialog container
    options[:trigger_class] ||= '' # Custom class for the trigger element
    button_classes = "#{options[:class]} #{options[:variant_classes]}".strip
    button_classes = tw(button_classes)

    render 'components/ui/dialog', locals: {
      content: content,
      button_classes: button_classes,
      dialog_class: options[:dialog_class],
      trigger_class: options[:trigger_class]
    }
  end

  def dialog_trigger(**options, &block)
    content_for :dialog_trigger, capture(&block), flush: true
  end

  def dialog_content(**options, &block)
    content_for :dialog_content, capture(&block), flush: true
  end
end
