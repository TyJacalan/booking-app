class Shadcn::SelectComponent
  include ComponentsHelper
  attr_reader :name, :id, :selected, :disabled, :view_context

  def initialize(name:, id:, view_context:, selected: nil, disabled: nil, data: {}, **options, &block)
    @name = name
    @id = id
    @view_context = view_context
    @selected = selected
    @disabled = disabled
    @options = options
    @data = data
    @content = view_context.capture(self, &block) if block
  end

  def option(value:, label: nil, &block)
    content = label || view_context.capture(&block)
    option_options = { value: }
    option_options[:selected] = 'selected' if value == selected
    option_options[:disabled] = 'disabled' if value == disabled
    view_context.content_tag :option, content, option_options
  end

  def call
    select_options = { name:,
                       id:,
                       class: tw(
                         'rounded-md border border-input bg-background px-3 py-2 text-sm ring-offset-background placeholder:text-muted-foreground focus:outline-none focus:ring-2 focus:ring-ring focus:ring-offset-2 disabled:cursor-not-allowed disabled:opacity-50', @options[:class]
                       ) }
    select_options[:data] = @data unless @data.empty?
    view_context.content_tag :select, @content, select_options
  end
end