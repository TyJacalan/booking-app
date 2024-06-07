module Components::SelectHelper
  def render_select(name:, id:, data: {}, **options, &block)
    component = Shadcn::SelectComponent.new(name:, id:, view_context: self, data:, **options, &block)
    component.call
  end
end
