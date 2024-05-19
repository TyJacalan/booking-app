module Components::TextareaHelper
  def render_textarea(name:, label: nil, id: nil, value: nil, **options)
    options.reverse_merge!(rows: 3, required: false, disabled: false,
                           readonly: false, class: '', placeholder: 'Type here...')
    render partial: 'components/ui/textarea', locals: {
      label: label,
      name: name,
      value: value,
      id: id,
      options: options
    }
  end
end
