module Components::ToastHelper
  def render_toast(header: nil, description: nil, action: nil, class: nil, data: {}, variant: :default, **options)
    options[:class] ||= ''
    if variant == :destructive
      options[:class] << ' destructive group border-destructive bg-destructive text-destructive-foreground '
    end

    render 'components/ui/toast', header:, description:, action:, class:, data:, options:
  end
end
