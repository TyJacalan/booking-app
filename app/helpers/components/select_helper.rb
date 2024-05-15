module Components::SelectHelper
  def render_select(name:, data: {}, **options, &block)
    component = Shadcn::SelectComponent.new(name:, view_context: self, data:, **options, &block)
    component.call
  end
end
