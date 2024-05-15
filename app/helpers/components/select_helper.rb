module Components::SelectHelper
  def render_select(name:, data: {}, **options, &block)
    component = Shadcn::SelectComponent.new(name: name, view_context: self, data: data, **options, &block)
    component.call
  end
end
