module Components::TextareaHelper
  def render_textarea(name:, label: nil, id: nil, value: nil, **options, &block)
    options.reverse_merge!(rows: 3, required: false, disabled: false,
                           readonly: false, class: '', placeholder: 'Type here...')
    content = capture(&block) if block_given?
    render partial: 'components/ui/textarea', locals: {
      label: label,
      name: name,
      value: value,
      id: id,
      options: options,
      content: content
    }
  end
end
